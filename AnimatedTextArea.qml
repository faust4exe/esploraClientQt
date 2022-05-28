import QtQuick 2.15
import QtQuick.Controls 2.15

TextArea {
    id: root

    property string nextText: ""
    property int moveDirection: -1

    wrapMode: Text.WrapAnywhere
    selectByMouse: true

    onNextTextChanged: {
        if(nextText == "") {
            return
        }
        switchAnimation.start()
    }

    SequentialAnimation {
        id: switchAnimation

        ParallelAnimation{
            NumberAnimation {
                target: root
                property: "x"
                from: 0
                to: moveDirection * 50
                duration: 500
            }

            NumberAnimation {
                target: root
                property: "opacity"
                duration: 500
                to: 0
            }
        }

        ScriptAction {
            script: {
                root.text = nextText
                nextText = ""
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "x"
                from: -moveDirection * 50
                to: 0
                duration: 500
            }

            NumberAnimation {
                target: root
                property: "opacity"
                duration: 500
                to: 1
            }
        }
    }
}
