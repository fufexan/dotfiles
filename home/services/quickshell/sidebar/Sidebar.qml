import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.utils

LazyLoader {
    active: Config.showSidebar

    PanelWindow {
        id: root

        screen: Config.preferredMonitor
        visible: true

        anchors {
            right: true
            top: true
            bottom: true
        }
        margins {
            top: Config.barHeight
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
                topMargin: Config.padding
                rightMargin: Config.padding
                bottomMargin: Config.padding * 5
            }

            Calendar {}
            NotificationCenter {}
        }
    }
}
