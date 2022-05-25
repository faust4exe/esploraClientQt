#include "esplorafetcher.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>

EsploraFetcher::EsploraFetcher()
{
    m_networkManager = new QNetworkAccessManager(this);
}

void EsploraFetcher::fetchData()
{
    QNetworkRequest request;
    request.setUrl(QUrl("http://qt-project.org"));
    request.setRawHeader("User-Agent", "MyOwnBrowser 1.0");

    m_reply = m_networkManager->get(request);
    connect(m_reply, &QIODevice::readyRead,
            this, &EsploraFetcher::onReplyFinished);
    connect(m_reply, &QNetworkReply::errorOccurred,
            this, &EsploraFetcher::onErrorOccured);
    connect(m_reply, &QNetworkReply::sslErrors,
            this, &EsploraFetcher::onSslError);


}

void EsploraFetcher::onReplyFinished()
{
    QString replyData(m_reply->readAll());
    emit dataReady(replyData);
}

void EsploraFetcher::onErrorOccured()
{

}

void EsploraFetcher::onSslError()
{

}

