import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

Item {
    id: item2
    height: 480
    width: 640

    BusyIndicator {
        id: busyIndicator
        visible: false
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Frame {
        id: mainFrame
        anchors.fill: parent
        enabled: !busyIndicator.visible

        RowLayout {
            id: searchLayout
            height: 46
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 10

            Label {
                id: searchLabel
                text: qsTr("Search for")
            }

            TextField {
                id: searchTextField
                Layout.fillWidth: true
                placeholderText: qsTr("Block hash")
                selectByMouse: true
            }

            Button {
                id: searchButton
                text: qsTr("Search")
                Layout.minimumWidth: 100
                onClicked: {
                    busyIndicator.visible = true
                    textArea.title = qsTr("Block info")
                    esploraFetcher.searchData(searchTextField.text)
                }
            }

            Button {
                id: transactionsButton
                text: qsTr("Transactions")
                onClicked: {
                    busyIndicator.visible = true
                    textArea.title = qsTr("Blocks transactions")
                    esploraFetcher.getTransactions(searchTextField.text)
                }
            }
        }

        RowLayout {
            id: actionsLayout
            y: 424
            height: 38
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10

            Button {
                id: loadButton
                text: qsTr("Load")
                Layout.minimumWidth: 100

                onClicked: {
                    busyIndicator.visible = true
                    textArea.title = qsTr("Latest blocks")
                    esploraFetcher.fetchData()
                }
            }

            Item {
                id: item1
                width: 200
                height: 200
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Button {
                id: prevButton
                text: qsTr("Previous")
                Layout.minimumWidth: 100
                onClicked: {
                    busyIndicator.visible = true
                    textArea.title = qsTr("Prev block")
                    esploraFetcher.getPrevBlock()
                }
            }

            Button {
                id: nextButton
                text: qsTr("Next")
                Layout.minimumWidth: 100
            }

        }

        TextArea {
            id: textArea

            property string title: ""
            property string value: ""
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            wrapMode: Text.WrapAnywhere
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 60
            anchors.topMargin: 68
            textFormat: Text.AutoText
            placeholderText: qsTr("Text Area")
            text: (title.length > 0 ? (title + ":\n") : "") + value
            selectByMouse: true
        }
    }

    Connections {
        target: esploraFetcher
        function onDataReady(data) {
            busyIndicator.visible = false
            textArea.value = data
        }
        function onSearchingBlock(hash) {
            searchTextField.text = hash
        }
    }
}


