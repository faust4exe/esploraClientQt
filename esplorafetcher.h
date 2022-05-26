#ifndef ESPLORAFETCHER_H
#define ESPLORAFETCHER_H

#include "qqmlengine.h"

#include <QJsonDocument>
#include <QFutureWatcher>
#include <QObject>
#include <QSslError>

class QNetworkReply;

class EsploraFetcher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isFetching READ isFetching NOTIFY isFetchingChanged)
    Q_PROPERTY(QStringList blocksList READ blocksList NOTIFY blocksListChanged)
    Q_PROPERTY(QStringList transactionsList READ transactionsList NOTIFY transactionsListChanged)

public:
    enum RequestType {
        Undefined,
        BlocksList,
        BlockInfo,
        BlockAt,
        TransactionsList,
        TransactionInfo
    };

    EsploraFetcher();
    ~EsploraFetcher();

    Q_INVOKABLE void fetchData();
    Q_INVOKABLE void searchData(const QString &hash = QString());
    Q_INVOKABLE void getTransactions(const QString &hash);
    Q_INVOKABLE void getTransactionInfo(const QString &hash, const QString &txId);
    Q_INVOKABLE void getPrevBlock();
    Q_INVOKABLE void getNextBlock();

    const QStringList &blocksList() const;
    const QStringList &transactionsList() const;
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
    QJsonDocument parseDocument(const QByteArray &array) const;
    void updateBlocksList();
    void updateTransactionsList();


private:
    void getRequest(const QString &adress, RequestType type = Undefined);

private:
    QNetworkAccessManager *m_networkManager;
    QFutureWatcher<QJsonDocument> m_futureWatcher;
    QNetworkReply *m_reply;
    RequestType m_requestType;
    QByteArray m_replyArray;
    QJsonDocument m_jsonDoc;

    QStringList m_blocksList;
    QStringList m_transactionsList;
    bool m_isFetching = false;
};

#endif // ESPLORAFETCHER_H
