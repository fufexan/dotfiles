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
            top: Config.barHeight
        }

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:sidebar"
        color: 'transparent'

        implicitWidth: 360 + Config.padding * 6
        mask: Region { item: col }

        ColumnLayout {
            id: col
            spacing: Config.spacing
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                leftMargin: Config.padding * 4
                topMargin: Config.padding * 2
                rightMargin: Config.padding * 2
                bottomMargin: Config.padding * 4
            }

            Calendar {}
            NotificationCenter {}
        }
    }
}
