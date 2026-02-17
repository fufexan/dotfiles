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

    Row {
        spacing: height / 7

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

            Rectangle {
                color: "transparent"
                required property var modelData

                implicitHeight: parent.height
                implicitWidth: {
                    if (modelData.workspace?.focused ?? false) {
                        return parent.height;
                    }
                    return parent.height * 0.3;
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 325
                        easing.type: Easing.OutQuint
                    }
                }

                WrapperMouseArea {
                    id: ws
                    property var modelData: parent.modelData
                    anchors {
                        fill: parent
                        margins: {
                            if (ws.modelData.workspace?.focused ?? false) {
                                return parent.height * 0.3;
                            }
                            return parent.height * 0.35;
                        }
                        leftMargin: 0
                        rightMargin: 0

                        Behavior on margins {
                            NumberAnimation {
                                duration: 325
                                easing.type: Easing.OutQuint
                            }
                        }
                    }

                    onPressed: Hyprland.dispatch(`workspace ${modelData.index}`)

                    Item {
                        anchors.fill: parent

                        Rectangle {
                            id: wsRect
                            radius: height / 2

                            anchors.fill: parent

                            Behavior on color {
                                ColorAnimation {
                                    duration: 325
                                    easing.type: Easing.OutQuint
                                }
                            }
                            color: {
                                ws.modelData.workspace ?? false ? Colors.monitorColors[ws.modelData.workspace?.monitor?.id ?? 0] : Colors.bgBar;
                            }
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
}
