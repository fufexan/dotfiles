import Quickshell
import Quickshell.Widgets
import "../utils/."

PopupWindow {
    id: root

    required property var targetItem
    required property var targetRect
    required property string targetText

    color: "transparent"

    anchor {
        item: targetItem
        rect: targetRect
        margins.top: 2
        gravity: Edges.Bottom
    }

    implicitHeight: textRect.implicitHeight
    implicitWidth: textRect.implicitWidth

    WrapperRectangle {
        id: textRect

        color: Colors.bgBlur
        margin: 6
        radius: 8

        Text {
            text: root.targetText
        }
    }
}
