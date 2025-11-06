import org.kde.kirigami
import QtQuick
import Quickshell
import "../utils/."

HoverTooltip {
    id: root

    required property string icon

    implicitWidth: height

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton

    Rectangle {
        radius: root.implicitWidth
        color: root.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
        implicitWidth: radius
        implicitHeight: radius

        Icon {
            source: Quickshell.iconPath(root.icon)
            anchors.centerIn: parent
            implicitHeight: parent.implicitHeight - 4
            implicitWidth: parent.implicitHeight - 4
            isMask: true
            color: Colors.foreground
        }
    }
}
