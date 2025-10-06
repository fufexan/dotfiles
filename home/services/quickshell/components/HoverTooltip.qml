import QtQuick
import Quickshell.Widgets

WrapperMouseArea {
    id: root

    property var rect: Qt.rect(root.width / 2, root.height + 8, 0, 0)
    required property string text
    default property alias contentItem: contentItem.data

    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    onEntered: timer.running = true
    onExited: {
        timer.running = false;
        tooltip.visible = false;
    }

    implicitWidth: contentItem.childrenRect.width
    implicitHeight: contentItem.childrenRect.height

    Timer {
        id: timer
        interval: 500
        repeat: false
        onTriggered: if (root.containsMouse)
            tooltip.visible = true
    }

    TextTooltip {
        id: tooltip
        targetItem: root
        targetRect: root.rect
        targetText: root.text
    }

    Item {
        id: contentItem
    }
}
