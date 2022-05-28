import QtQuick 2.15
import QtQuick.Controls 2.15

RoundButton {
    id: root

    property alias buttonImage: buttonImage
    property alias firstAnimation: firstAnimation
    property alias secondAnimation: secondAnimation
    property int imageOffset: 0

    implicitHeight: 20
    clip: true

    Image {
        id: buttonImage

        anchors.centerIn: parent

        sourceSize: Qt.size(width, height)
        height: parent.height * 0.6
        width: height
        opacity: enabled ? 1.0 : 0.5
        transformOrigin: Item.Center

        SequentialAnimation{
            id: animation

            NumberAnimation {
                id: firstAnimation

                target: root
                property: "imageOffset"
                duration: 500
                from: 0
            }

            NumberAnimation {
                id: secondAnimation

                target: root
                property: "imageOffset"
                duration: 500
                to: 0
            }
        }
    }

    ToolTip.visible: hovered

    onClicked: animation.start()
}
