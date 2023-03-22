import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

GroupBox {
    id: root

    title: qsTr("Block info")
    topPadding: 50

    label: RowLayout {
        height: 50

        Label {
            Layout.leftMargin: 15
            text: root.title
        }

        PrevRoundButton {
            onClicked: {
                esploraFetcher.blockInfoMoveDirection = 1
                esploraFetcher.selectedBlockHeight--
                esploraFetcher.getPrevBlock()
            }
        }

        NextRoundButton {
            onClicked: {
                esploraFetcher.blockInfoMoveDirection = -1
                esploraFetcher.selectedBlockHeight++
                esploraFetcher.getNextBlock()
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        AnimatedTextArea {
            id: blockInfoTextArea
            moveDirection: esploraFetcher.blockInfoMoveDirection
            nextText: esploraFetcher.blockInfoData

            Label {
                anchors.centerIn: parent
                opacity: 0.5
                text: qsTr("Select a block in list to fetch block details")
                visible: esploraFetcher.blocksList.length > 0
                         && blockInfoTextArea.text == ""
            }
        }
    }
}
