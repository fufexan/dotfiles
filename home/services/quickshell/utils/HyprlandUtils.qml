pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: hyprland

    property list<HyprlandWorkspace> workspaces: sortWorkspaces(Hyprland.workspaces.values)
    property HyprlandWorkspace focusedWorkspace: Hyprland.focusedMonitor?.activeWorkspace
    property int maxWorkspace: findMaxId()

    function sortWorkspaces(ws) {
        return [...ws].sort((a, b) => a?.id - b?.id);
    }

    function switchWorkspace(w: int): void {
        console.log(`workspace: focus ${focusedWorkspace.id} -> ${w}`);
        Hyprland.dispatch(`workspace ${w}`);
    }

    function findMaxId(): int {
        let num = hyprland.workspaces.length;
        return hyprland.workspaces[num - 1]?.id;
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            // console.log("EVENT NAME", event.name);
            // consow.wg("EVENT DATA", event.data);
            let eventName = event.name;

            switch (eventName) {
            // Both of these are required in order to detect workspace changes
            // even when switching monitors.
            // case "workspacev2":
            //     {
            //         // hyprland.focusedWorkspace = Hyprland.focusedMonitor?.activeWorkspace;
            //         console.log(`workspace: ${hyprland.focusedWorkspace.id}`);
            //         console.log(`num workspaces ${hyprland.workspaces.length}`)
            //         console.log(`num workspaces (real) ${Hyprland.workspaces.values.length}`)
            //         break;
            //     }
            // case "focusedmonv2":
            //     {
            //         // hyprland.focusedWorkspace = Hyprland.focusedMonitor?.activeWorkspace;
            //         console.log(`workspace: ${hyprland.focusedWorkspace.id}`);
            //         console.log(`num workspaces ${hyprland.workspaces.length}`)
            //         console.log(`num workspaces (real) ${Hyprland.workspaces.values.length}`)
            //         break;
            //     }
            case "createworkspacev2":
                {
                    hyprland.workspaces = hyprland.sortWorkspaces(Hyprland.workspaces.values);
                    hyprland.maxWorkspace = findMaxId();
                }
            case "destroyworkspacev2":
                {
                    hyprland.workspaces = hyprland.sortWorkspaces(Hyprland.workspaces.values);
                    hyprland.maxWorkspace = findMaxId();
                }
            }
        }
    }
}
