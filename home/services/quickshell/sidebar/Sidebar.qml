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
        }
        margins {
            top: Config.barHeight + 8
            right: 8
        }

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:sidebar"
        color: 'transparent'

        implicitWidth: 360
        implicitHeight: col.implicitHeight

        ColumnLayout {
            id: col
            anchors.fill: parent

            Calendar {}
        }
    }
}
