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

        RowLayout {
            id: searchLayout

            height: 30
            Layout.fillWidth: true

            Label {
                id: searchLabel

                text: qsTr("Current block")
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
                    blockInfoTextArea.moveDirection = 0
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
                        RefreshRoundButton {
                            onClicked: {
                                blocksListView.populateDirection = 0
                                esploraFetcher.fetchData()
                            }
                        }
                        UpRoundButton {
                            onClicked: {
                                blocksListView.populateDirection = -1
                                esploraFetcher.fetchNewer()
                            }
                        }
                        DownRoundButton {
                            onClicked: {
                                blocksListView.populateDirection = 1
                                esploraFetcher.fetchOlder()
                            }
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 350

                    AnimatedListView {
                        id: blocksListView

                        property int selectedBlockAt: -1

                        model: esploraFetcher.blocksList

                        Label {
                            anchors.centerIn: parent
                            opacity: 0.5
                            text: qsTr("Press refresh to fetch fresh items")
                            visible: blocksListView.count == 0
                        }

                        delegate: Rectangle {
                            id: blRoot

                            property bool isSelected: blocksListView.selectedBlockAt === modelData.blockHeight

                            x: isSelected ? 10 : 0
                            Behavior on x {
                                NumberAnimation { duration: 500 }
                            }

                            width: blocksListView.width - 20
                            height: 25

                            color: isSelected ? "#f3f3f3" : "#d3d3d3"
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
                                    blockInfoTextArea.moveDirection = 0
                                    blocksListView.selectedBlockAt = modelData.blockHeight
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
                        PrevRoundButton {
                            onClicked: {
                                blockInfoTextArea.moveDirection = 1
                                blocksListView.selectedBlockAt--
                                esploraFetcher.getPrevBlock()
                            }
                        }
                        NextRoundButton {
                            onClicked: {
                                blockInfoTextArea.moveDirection = -1
                                blocksListView.selectedBlockAt++
                                esploraFetcher.getNextBlock()
                            }
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true

                    ScrollView {
                        anchors.fill: parent
                        clip: true

                        AnimatedTextArea {
                            id: blockInfoTextArea

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

                    property int txShownIndex: 0
                    title: qsTr("Transactions list")

                    label: RowLayout {
                        Label {
                            Layout.leftMargin: 15
                            text: transactionsListGroupBox.title
                        }
                        RefreshRoundButton {
                            onClicked: {
                                transactionsListView.populateDirection = 0
                                transactionsListView.pressedIndex = -1
                                transactionsListGroupBox.txShownIndex = 0
                                esploraFetcher.getTransactions(searchTextField.text)
                            }
                        }
                        UpRoundButton {
                            onClicked: {
                                transactionsListView.populateDirection = -1
                                transactionsListView.pressedIndex = -1
                                transactionsListGroupBox.txShownIndex -= 25
                                esploraFetcher.getTransactions(searchTextField.text,
                                                               transactionsListGroupBox.txShownIndex)
                            }
                        }
                        DownRoundButton {
                            onClicked: {
                                transactionsListView.populateDirection = 1
                                transactionsListView.pressedIndex = -1
                                transactionsListGroupBox.txShownIndex += 25
                                esploraFetcher.getTransactions(searchTextField.text,
                                                               transactionsListGroupBox.txShownIndex)
                            }
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 250

                    AnimatedListView {
                        id: transactionsListView

                        property string selectedTxId: ""
                        property int pressedIndex: -1
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
                            visible: blocksListView.count > 0
                                     && searchTextField.text != ""
                                     && transactionsListView.count == 0
                        }

                        model: esploraFetcher.transactionsList

                        delegate: Rectangle {
                            id: txRoot

                            property string txId: modelData.txId
                            property bool isSelected: txId === transactionsListView.selectedTxId

                            x: isSelected ? 10 : 0
                            Behavior on x {
                                NumberAnimation { duration: 500 }
                            }

                            color: isSelected ? "#f3f3f3" : "#d3d3d3"
                            border.color: "#000000"
                            border.width: 1
                            opacity: enabled ? 1.0 : 0.5

                            width: transactionsListView.width - 20
                            height: 25

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                Label {
                                    id: textItem1
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

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    txTextArea.moveDirection = 0
                                    transactionsListView.pressedIndex = index
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
                        PrevRoundButton {
                            onClicked: {
                                txTextArea.moveDirection = 1
                                transactionsListView.pressedIndex++
                            }
                        }
                        NextRoundButton {
                            onClicked: {
                                txTextArea.moveDirection = -1
                                transactionsListView.pressedIndex--
                            }
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.fillHeight: true
                    SplitView.fillWidth: true

                    ScrollView {
                        anchors.fill: parent

                        AnimatedTextArea {
                            id: txTextArea

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
            blockInfoTextArea.nextText = data
        }
        function onTransactionDataReady(data) {
            txTextArea.nextText = data
        }

        function onSearchingBlock(hash) {
            searchTextField.text = hash
        }
    }
}


