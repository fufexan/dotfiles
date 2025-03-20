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

        spacing: 5

        // sample workspace indicators
        Repeater {
            id: repeater

            model: HyprlandUtils.maxWorkspace

            Workspace {
                required property int index
                property HyprlandWorkspace currWorkspace: HyprlandUtils.workspaces[index] || null
                property bool nonexistent: currWorkspace === null
                color: {
                    if (nonexistent) {
                        return Colors.bgBlur
                    } else if (currWorkspace === HyprlandUtils.focusedWorkspace) {
                        return Colors.fg
                    } else {
                        return Colors.bgBar
                    }
                }
            }

            // Rectangle {
            //     color: 'yellow'
            //     Layout.preferredWidth: parent.height * 0.4
            //     Layout.preferredHeight: parent.height * 0.4
            //     Layout.alignment: Qt.AlignHCenter
            //     radius: height / 2
            // }
        }
    }
}
