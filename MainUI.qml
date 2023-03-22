import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

Item {

    width: 1280
    height: 768

    BusyIndicator {
        id: busyIndicator

        visible: esploraFetcher.isFetching
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        z:1
    }

    ColumnLayout {
        id: mainFrame

        anchors.fill: parent
        anchors.margins: 5
        enabled: !busyIndicator.visible
        spacing: 10

        SearchBarRow {
            Layout.fillWidth: true
        }

        SplitView {
            width: 1248
            height: 640

            Layout.fillHeight: true
            Layout.fillWidth: true

            SplitView {
                orientation: Qt.Vertical

                SplitView.minimumWidth: 50
                SplitView.preferredWidth: 550

                BlocksListGroupBox {
                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 350
                }

                BlockInfoGroupBox {
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true
                    SplitView.minimumHeight: 50
                }
            }

            SplitView {
                orientation: Qt.Vertical

                SplitView.minimumWidth: 50
                SplitView.preferredWidth: 600

                TransactionsListGroupBox {
                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 250
                }

                TransactionInfoGroupBox {
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true
                    SplitView.minimumHeight: 50
                }
            }
        }
    }
}


