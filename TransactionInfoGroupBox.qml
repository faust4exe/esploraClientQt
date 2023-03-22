import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

GroupBox {
    id: transactionInfoGroupBox

    title: qsTr("Transaction Info")
    topPadding: 50

    label: RowLayout {
        height: 50

        Label {
            Layout.leftMargin: 15
            text: transactionInfoGroupBox.title
        }

        PrevRoundButton {
            onClicked: {
                esploraFetcher.transactionInfoMoveDirection = 1
                esploraFetcher.transactionsListSelectedIndex++
            }
        }

        NextRoundButton {
            onClicked: {
                esploraFetcher.transactionInfoMoveDirection = -1
                esploraFetcher.transactionsListSelectedIndex--
            }
        }
    }

    ScrollView {
        anchors.fill: parent

        AnimatedTextArea {
            id: txTextArea
            moveDirection: esploraFetcher.transactionInfoMoveDirection
            nextText: esploraFetcher.transactionInfoData

            Label {
                anchors.centerIn: parent
                opacity: 0.5
                text: qsTr("Select a transaction in list to fetch its details")
                visible: txTextArea.text == ""
                         && esploraFetcher.transactionsList.length > 0
            }
        }
    }
}
