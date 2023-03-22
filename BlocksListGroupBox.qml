import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

GroupBox {
    id: root

    property alias listView: blocksListView

    title: qsTr("Blocks list")
    topPadding: 50

    label: RowLayout {
        height: 50

        Label {
            Layout.leftMargin: 15
            text: root.title
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

    AnimatedListView {
        id: blocksListView

        model: esploraFetcher.blocksList

        Label {
            anchors.centerIn: parent
            opacity: 0.5
            text: qsTr("Press refresh to fetch fresh items")
            visible: blocksListView.count == 0
        }

        delegate: ListViewDelegate {
            isSelected: esploraFetcher.selectedBlockHeight === modelData.blockHeight

            width: blocksListView.width - 20

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5

                Label {
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

            onClicked: {
                esploraFetcher.blockInfoMoveDirection = 0
                esploraFetcher.selectedBlockHeight = modelData.blockHeight
                esploraFetcher.selectedBlockId = modelData.blockId
                esploraFetcher.searchData(modelData.blockId)
            }
        }
    }
}
