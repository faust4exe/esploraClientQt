import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11

Item {
    id: item2
    height: 480
    width: 640

    BusyIndicator {
        id: busyIndicator
        visible: false
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Timer {
        id: loadTimer
        interval: 5000
        running: busyIndicator.visible
        onTriggered: busyIndicator.visible = false
    }

    Frame {
        id: mainFrame
        anchors.fill: parent
        enabled: !busyIndicator.visible

        RowLayout {
            id: searchLayout
            height: 46
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 10

            Label {
                id: searchLabel
                text: qsTr("Search for")
            }

            TextField {
                id: searchTextField
                Layout.fillWidth: true
                placeholderText: qsTr("Block hash")
            }

            Button {
                id: searchButton
                text: qsTr("Search")
                Layout.minimumWidth: 100
            }
        }

        RowLayout {
            id: actionsLayout
            y: 424
            height: 38
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10

            Button {
                id: loadButton
                text: qsTr("Load")
                Layout.minimumWidth: 100

                onClicked: busyIndicator.visible = true
            }

            Item {
                id: item1
                width: 200
                height: 200
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Button {
                id: prevButton
                text: qsTr("Previous")
                Layout.minimumWidth: 100
            }

            Button {
                id: nextButton
                text: qsTr("Next")
                Layout.minimumWidth: 100
            }

        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}D{i:4}D{i:8}
}
##^##*/
