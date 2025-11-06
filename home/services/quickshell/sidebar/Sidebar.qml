import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../utils/."

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
            top: Config.barHeight + 8
            right: 8
            bottom: 8
        }

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:sidebar"
        color: 'transparent'

        implicitWidth: 360
        mask: Region { item: col }

        ColumnLayout {
            id: col
            anchors {
                left: parent.left
                right: parent.right
            }

            Calendar {}
            NotificationCenter {}
        }
    }
}
