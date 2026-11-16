import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.utils

PanelWindow {
    id: root

    screen: Config.preferredMonitor
    // Kept alive and toggled. Recreating the layer-shell surface and the
    // shader-heavy card list on every click made rapid clicks queue up.
    visible: NotifClient.sidebarOpen

    anchors {
        right: true
        top: true
        bottom: true
    }

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:sidebar"
    color: 'transparent'

    implicitWidth: Config.notificationWidth + Config.padding * 6
    mask: Region { item: col }

    ColumnLayout {
        id: col
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            leftMargin: Config.padding * 5
            topMargin: Config.barHeight
            rightMargin: Config.padding
            bottomMargin: Config.padding * 5
        }

        Calendar {}
        NotificationCenter {}
    }
}
