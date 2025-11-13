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
        radius: Config.radius
        color: root.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
        implicitWidth: Config.iconSize + 2 * Config.padding
        implicitHeight: Config.iconSize + 2 * Config.padding

        Icon {
            source: Quickshell.iconPath(root.icon)
            anchors.centerIn: parent
            implicitHeight: Config.iconSize
            implicitWidth: Config.iconSize
            isMask: true
            color: Colors.foreground
        }
    }
}
