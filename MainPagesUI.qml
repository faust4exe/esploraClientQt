import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Window 2.15

ColumnLayout {
    anchors.fill: parent

    SearchBarRow {
        Layout.fillWidth: true
    }

    StackView {
        id: stackView

        Layout.fillHeight: true
        Layout.fillWidth: true

        initialItem: page1
    }

    RowLayout {
        Layout.alignment: Qt.AlignCenter
        Layout.fillWidth: true

        Button {
            text: "Blocks List"
            visible: stackView.currentItem != page1
            onClicked: stackView.replace(page1)
        }

        Button {
            text: "Block Details"
            visible: stackView.currentItem != page2
            onClicked: stackView.replace(page2)
        }

        Button {
            text: "Transactions List"
            visible: stackView.currentItem != page3
            onClicked: stackView.replace(page3)
        }

        Button {
            text: "Transaction Details"
            visible: stackView.currentItem != page4
            onClicked: stackView.replace(page4)
        }
    }

    Component {
        id: page1
        Page {
            BlocksListGroupBox {
                anchors.fill: parent
            }
        }
    }

    Component {
        id: page2
        Page {
            BlockInfoGroupBox {
                anchors.fill: parent
            }
        }
    }

    Component {
        id: page3
        Page {
            TransactionsListGroupBox {
                anchors.fill: parent
            }
        }
    }

    Component {
        id: page4
        Page {
            TransactionInfoGroupBox {
                anchors.fill: parent
            }
        }
    }
}
