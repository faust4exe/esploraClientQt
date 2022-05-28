import QtQuick 2.15
import QtQuick.Controls 2.15

AnimatedRoundButton {
    buttonImage.anchors.horizontalCenterOffset: imageOffset
    buttonImage.source: "images/next.svg"

    firstAnimation.to: 25
    secondAnimation.from: -25

    ToolTip.text: qsTr("Next")
}
