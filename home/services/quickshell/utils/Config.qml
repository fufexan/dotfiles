pragma Singleton

import Quickshell

Singleton {
    property var preferredMonitor: {
        return [...Quickshell.screens].sort().reverse()[0];
    }

    readonly property var notificationExpireTimeout: 10
}
