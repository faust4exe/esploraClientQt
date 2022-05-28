import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

RoundButton {
    implicitHeight: 20
    clip: true
    Image {
        id: buttonImage
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: offset
        property int offset: 0

        source: "images/next.svg"
        sourceSize: Qt.size(width, height)
        height: parent.height * 0.6
        width: height
        opacity: enabled ? 1.0 : 0.5
        transformOrigin: Item.Center
        SequentialAnimation{
            id: animation
            NumberAnimation {
                target: buttonImage
                property: "offset"
                duration: 500
                from: 0
                to: 25
            }
            NumberAnimation {
                target: buttonImage
                property: "offset"
                duration: 500
                from: -25
                to: 0
            }
        }
    }
    ToolTip.visible: hovered
    ToolTip.text: qsTr("Next")
    onClicked: animation.start()
}
