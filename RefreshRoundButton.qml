import QtQuick 2.15
import QtQuick.Controls 2.15

RoundButton {
    implicitHeight: 20
    Image {
        id: buttonImage
        anchors.centerIn: parent
        source: "images/refresh.svg"
        rotation: 180
        sourceSize: Qt.size(width, height)
        height: parent.height * 0.5
        width: height
        opacity: enabled ? 1.0 : 0.5
        transformOrigin: Item.Center
        NumberAnimation {
            id: refreshAnimation
            target: buttonImage
            property: "rotation"
            duration: 1000
            from: 180
            to: 540
        }
    }
    ToolTip.visible: hovered
    ToolTip.text: qsTr("Refresh")

    onClicked: refreshAnimation.start()
}
