pragma Singleton

import Quickshell

PersistentProperties {
    reloadableId: "persistedStates"

    property var preferredMonitor: {
        return [...Quickshell.screens].sort().reverse()[0];
    }
    property bool showSidebar: false
    property bool doNotDisturb: false

    readonly property int notificationExpireTimeout: 10
    readonly property int notificationIconSize: 48
    readonly property int notificationWidth: 360
    readonly property int hoverTimeoutMs: 500

    readonly property int barHeight: 32
    readonly property int osdWidth: 200

    readonly property int iconSize: 14
    readonly property real spacing: padding * 3
    readonly property int radius: padding * 4
    readonly property int padding: 4

    readonly property int blurMax: 16
    readonly property real shadowOpacity: 0.1
    readonly property int shadowVerticalOffset: 2
    readonly property bool shadowEnabled: true

    readonly property int osdTimeout: 1000
}
