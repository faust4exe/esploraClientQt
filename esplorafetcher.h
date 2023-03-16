#ifndef ESPLORAFETCHER_H
#define ESPLORAFETCHER_H

#include "qqmlengine.h"

#include <QJsonDocument>
#ifndef Q_OS_WASM
#include <QFutureWatcher>
#endif
#include <QObject>
#include <QSslError>

class QNetworkReply;

class EsploraFetcher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isFetching READ isFetching NOTIFY isFetchingChanged)
    Q_PROPERTY(QVariantList blocksList READ blocksList NOTIFY blocksListChanged)
    Q_PROPERTY(QVariantList transactionsList READ transactionsList NOTIFY transactionsListChanged)

public:
    enum RequestType {
        Undefined,
        BlocksList,
        BlockInfo,
        BlockAt,
        TransactionsList,
        TransactionInfo
    };

    EsploraFetcher(QObject *parent);
    ~EsploraFetcher();

    Q_INVOKABLE void fetchData();
    Q_INVOKABLE void fetchOlder();
    Q_INVOKABLE void fetchNewer();
    Q_INVOKABLE void searchData(const QString &hash = QString());
    Q_INVOKABLE void getTransactions(const QString &hash, const int height = 0);
    Q_INVOKABLE void getTransactionInfo(const QString &txId);
    Q_INVOKABLE void getPrevBlock();
    Q_INVOKABLE void getNextBlock();

    const QVariantList &blocksList() const;
    const QVariantList &transactionsList() const;
    bool isFetching() const;

signals:
    void dataReady(const QString &data);
    void transactionDataReady(const QString &data);
    void searchingBlock(const QString &hash);

    void blocksListChanged();
    void transactionsListChanged();
    void isFetchingChanged();

private slots:
    void onReplyFinished();
    void onErrorOccured();
    void onSslError(const QList<QSslError> &errors);
    void onEncrypted(QNetworkReply *reply);
    void parseFinished();

private:
    void parseResult(const QJsonDocument &result);
    QJsonDocument parseDocument(const QByteArray &array) const;
    void updateBlocksList();
    void updateTransactionsList();

private:
    void getRequest(const QString &adress, RequestType type = Undefined);

private:
    QNetworkAccessManager *m_networkManager = nullptr;
#ifndef Q_OS_WASM
    QFutureWatcher<QJsonDocument> m_futureWatcher;
#endif
    QNetworkReply *m_reply = nullptr;
    RequestType m_requestType;
    QByteArray m_replyArray;
    QJsonDocument m_jsonDoc;

    int m_lowestBlockHeight = -1;
    QVariantList m_blocksList;
    QVariantList m_transactionsList;
    bool m_isFetching = false;
};

#endif // ESPLORAFETCHER_H
