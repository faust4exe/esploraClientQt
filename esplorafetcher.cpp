#include "esplorafetcher.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>

const QString baseUrl("https://blockstream.info/api/");
const QString blockInfo("/block/:hash");
const QString blockTxs("/block/:hash/txs[/:start_index]");
const QString blocksList("/blocks[/:start_height]");
const QString lastHash("/blocks/tip/hash");

EsploraFetcher::EsploraFetcher()
{
    qDebug() << QSslSocket::supportsSsl()
             << QSslSocket::sslLibraryBuildVersionString()
             << QSslSocket::sslLibraryVersionString();

    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::encrypted,
            this, &EsploraFetcher::onEncrypted);
}

void EsploraFetcher::fetchData()
{
    searchData();
}

void EsploraFetcher::searchData(const QString &hash)
{
    const QString hashTag(":hash");
    QString infoHash = blockInfo;
    if(hash.isEmpty()){
        infoHash.replace("block/","blocks");
    }
    getRequest(baseUrl + infoHash.replace(hashTag, hash));
}

void EsploraFetcher::getTransactions(const QString &hash)
{
    QString theBlockTxs = blockTxs;
    theBlockTxs.replace(":hash", hash);
    theBlockTxs.replace("[/:start_index]", "");
    getRequest(baseUrl + theBlockTxs);
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

void EsploraFetcher::onReplyFinished()
{
    QByteArray dataArray = m_reply->readAll();
    QString replyData;

    qDebug() << "Reply w data: \n" << dataArray;

    m_jsonDoc = m_jsonDoc.fromJson(dataArray);
    if(m_jsonDoc.isNull()){
        replyData = dataArray;
    }
    else {
        replyData = m_jsonDoc.toJson(QJsonDocument::Indented);
    }


    emit dataReady(replyData);
}

void EsploraFetcher::onErrorOccured()
{

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

void EsploraFetcher::getRequest(const QString &adress)
{
    QNetworkRequest request;
    request.setUrl(QUrl(adress));

    m_reply = m_networkManager->get(request);
    connect(m_reply, &QIODevice::readyRead,
            this, &EsploraFetcher::onReplyFinished);
    connect(m_reply, &QNetworkReply::errorOccurred,
            this, &EsploraFetcher::onErrorOccured);
    connect(m_reply, &QNetworkReply::sslErrors,
            this, &EsploraFetcher::onSslError);
}

