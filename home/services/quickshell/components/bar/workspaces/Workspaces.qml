pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../../../utils"
import Quickshell.Hyprland

Rectangle {
    id: workspaces

    color: 'transparent'

    width: workspacesRow.implicitWidth
    Layout.fillHeight: true

    RowLayout {
        id: workspacesRow

        height: parent.height
        implicitWidth: (parent.height * 0.5 + spacing) * 2 - spacing
        anchors.centerIn: parent

        spacing: height / 7

        Repeater {
            id: repeater

            model: HyprlandUtils.maxWorkspace

            Workspace {
                id: ws
                required property int index
                property HyprlandWorkspace currWorkspace: Hyprland.workspaces.values.find(e => e.id == index + 1) || null
                property bool nonexistent: currWorkspace === null
                property bool focused: index + 1 === Hyprland.focusedMonitor.activeWorkspace.id

                Layout.preferredWidth: {
                    if (focused) {
                        return parent.height * 0.8;
                    } else {
                        return parent.height * 0.4;
                    }
                }

                color: {
                    if (nonexistent) {
                        return Colors.bgBlur;
                    } else {
                        return Colors.monitorColors[Hyprland.monitors.values.indexOf(Hyprland.workspaces.values.find(e => e.id === index + 1).monitor)];
                    }
                }
            }
        }
    }
}
