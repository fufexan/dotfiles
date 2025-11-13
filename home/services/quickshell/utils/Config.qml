pragma Singleton

import Quickshell

PersistentProperties {
    reloadableId: "persistedStates"

    property var preferredMonitor: {
        return [...Quickshell.screens].sort().reverse()[0];
    }
    property bool showSidebar: false

    readonly property int notificationExpireTimeout: 10
    readonly property int iconSize: 14
    readonly property int barHeight: 32
    readonly property real spacing: 12
    readonly property int radius: 16
    readonly property int padding: 4

    readonly property int osdTimeout: 1000
}
