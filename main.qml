import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 1280
    height: 768
    visible: true

    title: qsTr("Esplora Client")

    MainUI {
        id: mainUI
        anchors.fill: parent
    }
}
