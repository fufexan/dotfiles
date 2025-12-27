import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.utils

WrapperMouseArea {
    id: root

    Layout.fillHeight: true

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(QsWindow.window?.screen)
    readonly property int activeWorkspace: monitor?.activeWorkspace?.id ?? 1
    property int shownWorkspaces: 10
    property int baseWorkspace: Math.floor((activeWorkspace - 1) / shownWorkspaces) * shownWorkspaces + 1

    property int scrollAccumulator: 0

    acceptedButtons: Qt.NoButton

    onWheel: event => {
        event.accepted = true;
        let acc = Math.abs(scrollAccumulator - event.angleDelta.x - event.angleDelta.y);
        const sign = Math.sign(acc);
        acc = Math.abs(acc);

        const offset = sign * Math.floor(acc / 120);
        scrollAccumulator = sign * (acc % 120);

        if (offset) {
            const currentWorkspace = root.activeWorkspace;
            const targetWorkspace = currentWorkspace + offset;
            const id = Math.max(baseWorkspace, Math.min(baseWorkspace + shownWorkspaces - 1, targetWorkspace));
            if (id != currentWorkspace)
                Hyprland.dispatch(`workspace ${id}`);
        }
    }

    RowLayout {
        spacing: height / 7
        anchors.centerIn: parent

        Repeater {
            id: repeater

            model: ScriptModel {
                objectProp: "index"
                values: {
                    const workspaces = Hyprland.workspaces.values;
                    const base = root.baseWorkspace;
                    return Array.from({
                        length: root.shownWorkspaces
                    }, (_, i) => ({
                                index: base + i,
                                workspace: workspaces.find(w => w.id == base + i)
                            }));
                }
            }

            WrapperMouseArea {
                id: ws
                required property var modelData
                implicitHeight: parent.height * 0.4

                onPressed: Hyprland.dispatch(`workspace ${modelData.index}`)

                Item {
                    implicitHeight: parent.height
                    implicitWidth: {
                        if (ws.modelData.workspace?.focused ?? false) {
                            return parent.height * 2;
                        }
                        return parent.height;
                    }
                    Rectangle {
                        id: wsRect
                        radius: height / 2

                        color: {
                            ws.modelData.workspace ?? false ? Colors.monitorColors[ws.modelData.workspace?.monitor?.id] : Colors.bgBar;
                        }

                        implicitHeight: parent.height
                        implicitWidth: parent.width
                    }
                    MultiEffect {
                        source: wsRect
                        anchors.fill: wsRect
                        shadowEnabled: Config.shadowEnabled
                        shadowVerticalOffset: Config.shadowVerticalOffset
                        blurMax: Config.blurMax
                        opacity: Config.shadowOpacity
                    }
                }
            }
        }
    }
}
