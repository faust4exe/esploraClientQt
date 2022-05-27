import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

Item {
    id: item2

    width: 1280
    height: 768

    BusyIndicator {
        id: busyIndicator
        visible: esploraFetcher.isFetching
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        z:1
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
                    esploraFetcher.searchData(searchTextField.text)
                }
            }

            Button {
                id: transactionsButton
                text: qsTr("Transactions")
                onClicked: {
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
                    esploraFetcher.fetchData()
                }
            }

            Button {
                id: prevButton
                text: qsTr("Previous")
                Layout.minimumWidth: 100
                onClicked: {
                    esploraFetcher.getPrevBlock()
                }
            }

            Button {
                id: nextButton
                text: qsTr("Next")
                Layout.minimumWidth: 100
                onClicked: {
                    esploraFetcher.getNextBlock()
                }
            }

            Item {
                id: item1
                width: 200
                height: 200
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        SplitView {
            x: 10
            y: 62
            width: 1248
            height: 640

            SplitView {
                orientation: Qt.Vertical

                SplitView.minimumWidth: 50
                SplitView.preferredWidth: 550

                GroupBox {
                    id: blocksGroupBox

                    title: qsTr("Blocks list")

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 350

                    ListView {
                        id: blocksListView

                        anchors.fill: parent

                        clip: true
                        interactive: true
                        model: esploraFetcher.blocksList

                        delegate: Item {
                            x: 6
                            width: textItem.width
                            height: 30

                            Label {
                                id: textItem
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: -5
                                    color: "lightgray"
                                    border.width: 1
                                    border.color: "black"
                                    opacity: enabled ? 1.0 : 0.5
                                    z: -1

                                    MouseArea {
                                        anchors.fill: parent
                                        onDoubleClicked: {
                                            searchTextField.text = modelData
                                            esploraFetcher.searchData(searchTextField.text)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                GroupBox {
                    id: blockInfoGroupBox

                    title: qsTr("Block info")

                    SplitView.minimumHeight: 50
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true

                    ScrollView {
                        anchors.fill: parent
                        clip: true

                        TextArea {
                            id: blockInfoTextArea

                            wrapMode: Text.WrapAnywhere
                            selectByMouse: true
                        }
                    }
                }
            }

            SplitView {

                x: 620
                y: 62
                width: 638
                height: 640
                orientation: Qt.Vertical

                SplitView.minimumWidth: 50
                SplitView.preferredWidth: 600

                GroupBox {
                    id: transactionsListGroupBox

                    title: qsTr("Transactions list")

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 250

                    ListView {
                        id: transactionsListView

                        anchors.fill: parent
                        clip: true
                        interactive: true

                        model: esploraFetcher.transactionsList
                        delegate: Item {
                            x: 6
                            width: textItem1.width
                            height: 30
                            Label {
                                id: textItem1
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    color: "#d3d3d3"
                                    border.color: "#000000"
                                    border.width: 1
                                    opacity: enabled ? 1.0 : 0.5
                                    anchors.fill: parent
                                    anchors.margins: -5
                                    MouseArea {
                                        anchors.fill: parent
                                        onDoubleClicked: {
                                            esploraFetcher.getTransactionInfo(searchTextField.text, modelData)
                                        }
                                    }
                                    z: -1
                                }
                            }
                        }
                    }
                }

                GroupBox {
                    id: transactionInfoGroupBox

                    title: qsTr("Transaction Info")

                    SplitView.minimumHeight: 50
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true

                    ScrollView {
                        anchors.fill: parent

                        TextArea {
                            id: txTextArea

                            wrapMode: Text.WrapAnywhere
                            selectByMouse: true
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: esploraFetcher
        function onDataReady(data) {
            blockInfoTextArea.text = data
        }
        function onTransactionDataReady(data) {
            txTextArea.text = data
        }

        function onSearchingBlock(hash) {
            searchTextField.text = hash
        }
    }
}


