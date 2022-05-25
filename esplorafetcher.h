#ifndef ESPLORAFETCHER_H
#define ESPLORAFETCHER_H

#include "qqmlengine.h"

#include <QJsonDocument>
#include <QObject>
#include <QSslError>

class QNetworkReply;

class EsploraFetcher : public QObject
{
    Q_OBJECT
public:
    EsploraFetcher();
    Q_INVOKABLE void fetchData();
    Q_INVOKABLE void searchData(const QString &hash = QString());
    Q_INVOKABLE void getTransactions(const QString &hash);
    Q_INVOKABLE void getPrevBlock();

signals:
    void dataReady(const QString &data);
    void searchingBlock(const QString &hash);

private slots:
    void onReplyFinished();
    void onErrorOccured();
    void onSslError(const QList<QSslError> &errors);
    void onEncrypted(QNetworkReply *reply);

private:
    void getRequest(const QString &adress);

private:
    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_reply;
    QJsonDocument m_jsonDoc;
};

#endif // ESPLORAFETCHER_H
