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
                            onClicked: esploraFetcher.fetchNewer()
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/down.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Older")
                            onClicked: esploraFetcher.fetchOlder()
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 350

                    ListView {
                        id: blocksListView

                        property int selectedBlockAt: -1

                        anchors.fill: parent

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

                        ScrollBar.vertical: ScrollBar {}

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
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/previous.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Previous")
                            onClicked: {
                                blocksListView.selectedBlockAt--
                                esploraFetcher.getPrevBlock()
                            }
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/next.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Next")
                            onClicked: {
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

                    property int txShownIndex: 0
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
                            onClicked: {
                                transactionsListView.pressedIndex = -1
                                transactionsListGroupBox.txShownIndex = 0
                                esploraFetcher.getTransactions(searchTextField.text)
                            }
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/up.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Newer")
                            onClicked: {
                                transactionsListView.pressedIndex = -1
                                transactionsListGroupBox.txShownIndex -= 25
                                esploraFetcher.getTransactions(searchTextField.text,
                                                               transactionsListGroupBox.txShownIndex)
                            }
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/down.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Older")
                            onClicked: {
                                transactionsListView.pressedIndex = -1
                                transactionsListGroupBox.txShownIndex += 25
                                esploraFetcher.getTransactions(searchTextField.text,
                                                               transactionsListGroupBox.txShownIndex)
                            }
                        }
                    }

                    SplitView.minimumHeight: 50
                    SplitView.preferredHeight: 250

                    ListView {
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
                        ScrollBar.vertical: ScrollBar {}

                        model: esploraFetcher.transactionsList
                        spacing: 5

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
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/previous.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Previous")
                            onClicked: transactionsListView.pressedIndex++
                        }
                        RoundButton {
                            implicitHeight: 20
                            icon.source: "images/next.svg"
                            ToolTip.visible: hovered
                            ToolTip.text: qsTr("Next")
                            onClicked: transactionsListView.pressedIndex--
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


