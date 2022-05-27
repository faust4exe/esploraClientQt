import QtQuick 2.0
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

        RowLayout {
            id: searchLayout

            height: 30
            Layout.fillWidth: true

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


                GroupBox {
                    id: blocksGroupBox

                    title: qsTr("Blocks list")

                    label: RowLayout {
                        Label {
                            Layout.leftMargin: 15
                            text: blocksGroupBox.title
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/refresh.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Refresh")
                            onClicked: esploraFetcher.fetchData()
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/up.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Newer")
//                            onClicked: esploraFetcher.getPrevBlock()
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/down.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Older")
//                            onClicked: esploraFetcher.getNextBlock()
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 350

                    ListView {
                        id: blocksListView

                        anchors.fill: parent

                        property int pressedIndex: -1
                        clip: true
                        interactive: true
                        model: esploraFetcher.blocksList
                        spacing: 5

                        Label {
                            anchors.centerIn: parent
                            opacity: 0.5
                            text: qsTr("Press refresh to fetch fresh items")
                            visible: blocksListView.count == 0
                        }

                        delegate: Rectangle {
                            id: blRoot

                            width: blocksListView.width
                            height: 25

                            color: blocksListView.pressedIndex !== index ? "#d3d3d3" : "#f3f3f3"
                            border.width: 1
                            border.color: "black"
                            opacity: enabled ? 1.0 : 0.5

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5

                                Label {
                                    id: textItem
                                    text: modelData.blockId

                                    elide: Text.ElideLeft

                                    Layout.alignment: Qt.AlignVCenter
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: " @" + modelData.blockHeight
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Label {
                                    text: " #" + modelData.blockTimestamp
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    blocksListView.pressedIndex = index
                                    searchTextField.text = modelData.blockId
                                    esploraFetcher.searchData(searchTextField.text)
                                }
                            }
                        }
                    }
                }

                GroupBox {
                    id: blockInfoGroupBox

                    title: qsTr("Block info")
                    topPadding: 50

                    label: RowLayout {
                        height: 50
                        Label {
                            Layout.leftMargin: 15
                            text: blockInfoGroupBox.title
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/previous.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Previous")
                            onClicked: esploraFetcher.getPrevBlock()
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/next.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Next")
                            onClicked: esploraFetcher.getNextBlock()
                        }
                    }

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

                            Label {
                                anchors.centerIn: parent
                                opacity: 0.5
                                text: qsTr("Select a block in list to fetch block details")
                                visible: blocksListView.count > 0 && blockInfoTextArea.text == ""
                            }
                        }
                    }
                }
            }

            SplitView {
                orientation: Qt.Vertical

                SplitView.minimumWidth: 50
                SplitView.preferredWidth: 600

                GroupBox {
                    id: transactionsListGroupBox

                    title: qsTr("Transactions list")

                    label: RowLayout {
                        Label {
                            Layout.leftMargin: 15
                            text: transactionsListGroupBox.title
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/refresh.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Refresh")
                            onClicked: esploraFetcher.getTransactions(searchTextField.text)
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 250

                    ListView {
                        id: transactionsListView

                        property int pressedIndex: -1
                        anchors.fill: parent
                        clip: true
                        interactive: true

                        Label {
                            anchors.centerIn: parent
                            opacity: 0.5
                            text: qsTr("Press refresh to fetch block transactions")
                            visible: blocksListView.count > 0
                                     && searchTextField.text != ""
                                     && transactionsListView.count == 0
                        }

                        model: esploraFetcher.transactionsList
                        delegate: Item {
                            id: txRoot
                            x: 6
                            width: textItem1.width
                            height: 30
                            Label {
                                id: textItem1
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    color: transactionsListView.pressedIndex !== index ? "#d3d3d3" : "#f3f3f3"
                                    border.color: "#000000"
                                    border.width: 1
                                    opacity: enabled ? 1.0 : 0.5
                                    anchors.fill: parent
                                    anchors.margins: -5
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            transactionsListView.pressedIndex = index
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
                    topPadding: 50

                    label: RowLayout {
                        height: 50
                        Label {
                            Layout.leftMargin: 15
                            text: transactionInfoGroupBox.title
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/previous.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Previous")
                            onClicked: transactionsListView.currentIndex--
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/next.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Next")
                            onClicked: transactionsListView.currentIndex++
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true

                    ScrollView {
                        anchors.fill: parent

                        TextArea {
                            id: txTextArea

                            wrapMode: Text.WrapAnywhere
                            selectByMouse: true

                            Label {
                                anchors.centerIn: parent
                                opacity: 0.5
                                text: qsTr("Select a transaction in list to fetch its details")
                                visible: txTextArea.text == "" && transactionsListView.count > 0
                            }
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


