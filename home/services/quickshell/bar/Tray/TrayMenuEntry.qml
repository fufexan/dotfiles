pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.utils
import org.kde.kirigami

Squircle {
    id: root
    required property QsMenuEntry modelData
    required property QsMenuOpener opener
    color: "transparent"
    radius: 10

    Layout.fillWidth: true

    signal openSubmenu(handle: QsMenuHandle)

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !root.modelData.isSeparator && root.modelData.enabled
        hoverEnabled: true
        onEntered: root.color = Colors.surface
        onExited: root.color = "transparent"
        onClicked: {
            if (root.modelData.hasChildren) {
                root.openSubmenu(root.modelData);
            } else {
                root.modelData.triggered();
            }
        }
    }

    implicitHeight: (root.modelData.isSeparator ? 1 : rowLayout.implicitHeight) + Config.padding * 2
    implicitWidth: rowLayout.implicitWidth + Config.padding * 2

    Rectangle {
        visible: root.modelData.isSeparator
        anchors.fill: parent
        anchors.margins: Config.padding
        color: Colors.innerBorder
    }

    RowLayout {
        id: rowLayout
        visible: !root.modelData.isSeparator

        spacing: Config.padding

        anchors.fill: parent
        anchors.margins: Config.padding

        Loader {
            id: loader

            active: root.modelData?.icon != ""
            visible: active

            sourceComponent: Icon {
                id: icon

                implicitWidth: Config.iconSize
                implicitHeight: Config.iconSize

                isMask: true
                color: Colors.foreground

                source: Utils.getImage(root.modelData.icon)
            }
        }

        Text {
            // Maintain vertical alignment when some entries have icons and some don't
            Layout.leftMargin: root.opener.children.values.some(e => e.icon != "") && !loader.active ? Config.iconSize + rowLayout.spacing : Config.padding * 0.5
            Layout.rightMargin: Config.padding * 0.5
            Layout.fillWidth: true

            text: root.modelData.text
            color: root.modelData.enabled ? Colors.foreground : Qt.lighter(Colors.foreground, 0.6)
        }

        MaterialIcon {
            visible: root.modelData.hasChildren
            text: "chevron_right"
            font.pointSize: Config.textSize
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignRight
        }
    }
}
