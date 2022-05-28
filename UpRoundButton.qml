import QtQuick 2.15
import QtQuick.Controls 2.15

AnimatedRoundButton {
   buttonImage.anchors.verticalCenterOffset: imageOffset
   buttonImage.source: "images/up.svg"
   buttonImage.height: height * 0.75

   firstAnimation.to: -15
   secondAnimation.from: 15

    ToolTip.text: qsTr("Newer")
}
