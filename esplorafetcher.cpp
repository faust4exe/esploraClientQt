#include "esplorafetcher.h"

#include <QtConcurrent>
#include <QFuture>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>

const QString c_baseUrl("https://blockstream.info/api");
const QString c_blockInfo("/block/:hash");
const QString c_blockTxs("/block/:hash/txs[/:start_index]");
const QString c_blockTxIds("/block/:hash/txids");
const QString c_transactionInfo("/tx/:txid");
const QString c_blocksList("/blocks/:start_height");
const QString c_lastHash("/blocks/tip/hash");
const QString c_blockAtHeight("/block-height/:height");

EsploraFetcher::EsploraFetcher()
{
    qDebug() << QSslSocket::supportsSsl()
             << QSslSocket::sslLibraryBuildVersionString()
             << QSslSocket::sslLibraryVersionString();

    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::encrypted,
            this, &EsploraFetcher::onEncrypted);
    connect(&m_futureWatcher, &QFutureWatcher<QJsonDocument>::finished,
            this, &EsploraFetcher::parseFinished);
}

EsploraFetcher::~EsploraFetcher()
{
    m_futureWatcher.cancel();
}

void EsploraFetcher::fetchData()
{
    searchData();
}

void EsploraFetcher::fetchOlder()
{
    QString theBlocksList = c_blocksList;

    theBlocksList.replace(":start_height",
                          QString::number(m_lowestBlockHeight - 1));

    getRequest(c_baseUrl + theBlocksList);
}

void EsploraFetcher::fetchNewer()
{
    QString theBlocksList = c_blocksList;

    theBlocksList.replace(":start_height",
                          QString::number(m_lowestBlockHeight + 19));

    getRequest(c_baseUrl + theBlocksList);
}

void EsploraFetcher::searchData(const QString &hash)
{
    QString infoHash = c_blockInfo;
    if(hash.isEmpty()){
        infoHash.replace("block/","blocks");
    }
    infoHash.replace(":hash", hash);
    getRequest(c_baseUrl + infoHash);
}

void EsploraFetcher::getTransactions(const QString &hash)
{
    QString theBlockTxIds = c_blockTxIds;

    theBlockTxIds.replace(":hash", hash);
    getRequest(c_baseUrl + theBlockTxIds, TransactionsList);
}

void EsploraFetcher::getTransactionInfo(const QString &hash, const QString &txId)
{
    QString theTxInfo = c_transactionInfo;

    theTxInfo.replace(":txid", txId);
    getRequest(c_baseUrl + theTxInfo, TransactionInfo);
}

void EsploraFetcher::getPrevBlock()
{
    QJsonObject jsonObj = m_jsonDoc.object();
    QJsonValue jsonValue = jsonObj.value("previousblockhash");
    if(!jsonValue.isNull()){
        const QString hash = jsonValue.toString();
        emit searchingBlock(hash);
        searchData(hash);
    }
}

void EsploraFetcher::getNextBlock()
{
    QJsonObject jsonObj = m_jsonDoc.object();
    QJsonValue jsonValue = jsonObj.value("height");
    if(!jsonValue.isNull()){
        const int nextHeight = jsonValue.toInt() + 1;

        QString theBlockAt = c_blockAtHeight;
        theBlockAt.replace(":height", QString::number(nextHeight));
        getRequest(c_baseUrl + theBlockAt, BlockAt);
    }
}

void EsploraFetcher::onReplyFinished()
{
    m_replyArray = m_reply->readAll();
    qDebug() << "Reply w data: \n" << m_replyArray;

    if(m_requestType == BlockAt){
        const QString hash = m_replyArray;
        emit searchingBlock(hash);
        searchData(hash);
        return;
    }

    QFuture<QJsonDocument> future =
            QtConcurrent::run(this, &EsploraFetcher::parseDocument, m_replyArray);
    m_futureWatcher.setFuture(future);
}

void EsploraFetcher::onErrorOccured()
{
    m_isFetching = false;
    emit isFetchingChanged();
}

void EsploraFetcher::onSslError(const QList<QSslError> &errors)
{
    qDebug() << "Got Ssl Errors : ";
    foreach(auto &error, errors) {
        qDebug() << error.errorString();
    }
}

void EsploraFetcher::onEncrypted(QNetworkReply *reply)
{
    qDebug() << "Got Encrypted Reply : "
             << reply->readAll();
}

void EsploraFetcher::parseFinished()
{
    m_jsonDoc = m_futureWatcher.result();

    QString replyData;
    if(m_jsonDoc.isNull()){
        replyData = m_replyArray;
        emit dataReady(replyData);
    }
    else if(m_requestType == TransactionsList) {
        updateTransactionsList();
    }
    else if(m_requestType == TransactionInfo) {
        replyData = m_jsonDoc.toJson(QJsonDocument::Indented);
        emit transactionDataReady(replyData);
    }
    else {
        if(m_jsonDoc.isArray()) {
            updateBlocksList();
        }
        else {
            replyData = m_jsonDoc.toJson(QJsonDocument::Indented);
            emit dataReady(replyData);
        }
    }

    m_isFetching = false;
    emit isFetchingChanged();
}

QJsonDocument EsploraFetcher::parseDocument(const QByteArray &array) const
{
    QJsonDocument jsonDoc = QJsonDocument::fromJson(array);

    return jsonDoc;
}

void EsploraFetcher::updateBlocksList()
{
    if(!m_jsonDoc.isArray()){
        return;
    }

    m_blocksList.clear();
    QJsonArray blocksArray = m_jsonDoc.array();
    foreach(const QJsonValue &blockItem, blocksArray) {
        const QJsonObject object = blockItem.toObject();
        const QString blockId = object.value("id").toString();
        const int height = object.value("height").toInt();
        const QDateTime timestamp =
            QDateTime::fromSecsSinceEpoch(object.value("timestamp").toInt());


        QVariantMap blockData;
        blockData.insert("blockId", blockId);
        blockData.insert("blockHeight", height);
        blockData.insert("blockTimestamp",
                         timestamp.toString(Qt::SystemLocaleShortDate));
        m_blocksList.append(blockData);
        m_lowestBlockHeight = height;
    }
    emit blocksListChanged();
}

void EsploraFetcher::updateTransactionsList()
{
    if(!m_jsonDoc.isArray()){
        return;
    }

    m_transactionsList.clear();
    QJsonArray transactionsArray = m_jsonDoc.array();
    foreach(const QJsonValue &transactionsId, transactionsArray) {
        const QString txId = transactionsId.toString();
        m_transactionsList.append(txId);
    }
    emit transactionsListChanged();
}

void EsploraFetcher::getRequest(const QString &adress, RequestType type)
{
    qDebug() << "Requesting " << adress;
    QNetworkRequest request;
    request.setUrl(QUrl(adress));

    m_isFetching = true;
    emit isFetchingChanged();

    m_requestType = type;
    m_reply = m_networkManager->get(request);
    connect(m_reply, &QNetworkReply::finished,
            this, &EsploraFetcher::onReplyFinished);
    connect(m_reply, &QNetworkReply::errorOccurred,
            this, &EsploraFetcher::onErrorOccured);
    connect(m_reply, &QNetworkReply::sslErrors,
            this, &EsploraFetcher::onSslError);
}


const QVariantList &EsploraFetcher::blocksList() const
{
    return m_blocksList;
}

const QStringList &EsploraFetcher::transactionsList() const
{
    return m_transactionsList;
}

bool EsploraFetcher::isFetching() const
{
    return m_isFetching;
}
