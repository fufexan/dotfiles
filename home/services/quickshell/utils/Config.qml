pragma Singleton

import Quickshell

Singleton {
    property var preferredMonitor: {
        return [...Quickshell.screens].sort().reverse()[0];
    }

    readonly property int notificationExpireTimeout: 10
    readonly property int iconSize: 14
    readonly property int barHeight: 32
    readonly property real spacing: 12

    readonly property int osdTimeout: 1000
}
