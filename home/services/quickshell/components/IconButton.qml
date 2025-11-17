import org.kde.kirigami
import QtQuick
import QtQuick.Effects
import Quickshell
import qs.utils

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
            id: iconItem
            source: Quickshell.iconPath(root.icon)
            anchors.centerIn: parent
            implicitHeight: Config.iconSize
            implicitWidth: Config.iconSize
            isMask: true
            color: Colors.foreground
        }

        MultiEffect {
            source: iconItem
            anchors.fill: iconItem
            shadowEnabled: Config.shadowEnabled
            shadowVerticalOffset: Config.shadowVerticalOffset
            blurMax: Config.blurMax
            opacity: Config.shadowOpacity
        }
    }
}
