pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.components
import qs.utils

Squircle {
    id: root
    required property QsMenuEntry modelData
    required property QsMenuOpener opener
    color: "transparent"
    radius: 10

    Layout.fillWidth: true

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.color = Colors.surface
        onExited: root.color = "transparent"
        onClicked: {
            root.modelData.triggered();
        }
    }

    implicitHeight: rowLayout.implicitHeight + Config.padding * 2
    implicitWidth: rowLayout.implicitWidth + Config.padding * 2

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        anchors.margins: Config.padding

        Loader {
            id: loader

            active: root.modelData?.icon != ""
            visible: active

            sourceComponent: IconImage {
                id: icon

                source: Utils.getImage(root.modelData.icon)
                mipmap: true
                implicitSize: Config.iconSize
            }
        }

        Text {
            // Maintain vertical alignment when some entries have icons and some don't
            Layout.leftMargin: root.opener.children.values.some(e => e.icon != "") && !loader.active ? Config.iconSize + rowLayout.spacing : 0
            Layout.fillWidth: true

            text: root.modelData.text
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
