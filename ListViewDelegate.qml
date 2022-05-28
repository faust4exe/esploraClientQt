import QtQuick 2.15

Rectangle {
    id: root

    property bool isSelected: false

    signal clicked()

    x: isSelected ? 10 : 0

    Behavior on x {
        NumberAnimation { duration: 500 }
    }

    height: 25

    color: isSelected ? "#f3f3f3" : "#d3d3d3"
    border.width: 1
    border.color: "black"
    opacity: enabled ? 1.0 : 0.5

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
