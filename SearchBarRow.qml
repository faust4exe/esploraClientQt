import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

RowLayout {
    id: root

    height: 30
    Label {
        text: qsTr("Current block")
    }

    TextField {
        id: searchTextField

        Layout.fillWidth: true
        placeholderText: qsTr("Block hash")
        selectByMouse: true
        text: esploraFetcher.selectedBlockId
    }

    Button {
        id: searchButton

        text: qsTr("Search")
        Layout.minimumWidth: 100

        onClicked: {
            esploraFetcher.blockInfoMoveDirection = 0
            esploraFetcher.searchData(searchTextField.text)
        }
    }
}
