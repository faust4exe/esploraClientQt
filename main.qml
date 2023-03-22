import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Window 2.15

Window {
    id: root
    width: 1280
    height: 768
    visible: true

    title: qsTr("Esplora Client")

    Loader {
        anchors.fill: parent
        sourceComponent: root.width < root.height
                         ? mobileUI
                         : desktopUI
    }

    Component {
        id: desktopUI
        MainUI { }
    }

    Component {
        id: mobileUI
        MainPagesUI { }
    }
}
