import QtQuick 2.15
import QtQuick.Controls 2.15

ListView {
    id: root

    property int populateDirection: 0

    anchors.fill: parent

    clip: true
    interactive: true
    spacing: 5

    ScrollBar.vertical: ScrollBar {}

    populate: Transition {
        id: theTrans
        NumberAnimation {
            property: "y"
            from: theTrans.ViewTransition.destination.y
                  + (root.populateDirection != 0 ? 25 * root.populateDirection : 0)
            to: theTrans.ViewTransition.destination.y
            duration: 500
        }
        NumberAnimation {
            property: "x"
            from: theTrans.ViewTransition.destination.x
                    + (root.populateDirection == 0 ? 25 : 0)
            to: theTrans.ViewTransition.destination.x
            duration: 500
        }
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
    }
}
