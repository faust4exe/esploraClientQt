import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

GroupBox {
    id: transactionsListGroupBox

    property int txShownIndex: 0

    title: qsTr("Transactions list")
    topPadding: 50

    label: RowLayout {
        height: 50

        Label {
            Layout.leftMargin: 15
            text: transactionsListGroupBox.title
        }

        RefreshRoundButton {
            onClicked: {
                transactionsListView.populateDirection = 0
                esploraFetcher.transactionsListSelectedIndex = -1
                transactionsListGroupBox.txShownIndex = 0
                esploraFetcher.getTransactions(esploraFetcher.selectedBlockId)
            }
        }

        UpRoundButton {
            onClicked: {
                transactionsListView.populateDirection = -1
                esploraFetcher.transactionsListSelectedIndex = -1
                transactionsListGroupBox.txShownIndex -= 25
                esploraFetcher.getTransactions(esploraFetcher.selectedBlockId,
                                               transactionsListGroupBox.txShownIndex)
            }
        }

        DownRoundButton {
            onClicked: {
                transactionsListView.populateDirection = 1
                esploraFetcher.transactionsListSelectedIndex = -1
                transactionsListGroupBox.txShownIndex += 25
                esploraFetcher.getTransactions(esploraFetcher.selectedBlockId,
                                               transactionsListGroupBox.txShownIndex)
            }
        }
    }

    AnimatedListView {
        id: transactionsListView

        property string selectedTxId: ""
        property int pressedIndex: esploraFetcher.transactionsListSelectedIndex

        onPressedIndexChanged: {
            if(pressedIndex < 0){
                return
            }

            selectedTxId = transactionsListView.itemAtIndex(pressedIndex).txId
            esploraFetcher.getTransactionInfo(selectedTxId)
        }

        Label {
            anchors.centerIn: parent
            opacity: 0.5
            text: qsTr("Press refresh to fetch block transactions")
            visible: esploraFetcher.blocksList.length > 0
                     && esploraFetcher.selectedBlockId != ""
                     && transactionsListView.count == 0
        }

        model: esploraFetcher.transactionsList

        delegate: ListViewDelegate {
            property string txId: modelData.txId

            isSelected: txId === transactionsListView.selectedTxId

            width: transactionsListView.width - 20

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5

                Label {
                    elide: Text.ElideLeft
                    text: modelData.txId
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                Label {
                    text: " fee:" + modelData.txFee
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            onClicked: {
                esploraFetcher.transactionInfoMoveDirection = 0
                esploraFetcher.transactionsListSelectedIndex = index
            }
        }
    }
}
