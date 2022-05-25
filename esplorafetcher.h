#ifndef ESPLORAFETCHER_H
#define ESPLORAFETCHER_H

#include "qqmlengine.h"
#include <QObject>

class QNetworkReply;

class EsploraFetcher : public QObject
{
    Q_OBJECT
public:
    EsploraFetcher();
    Q_INVOKABLE void fetchData();

signals:
    void dataReady(const QString &data);

private slots:
    void onReplyFinished();
    void onErrorOccured();
    void onSslError();

private:
    QNetworkAccessManager *m_networkManager;
    QNetworkReply *m_reply;
};

#endif // ESPLORAFETCHER_H
