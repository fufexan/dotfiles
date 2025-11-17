import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.utils

PanelWindow {
    id: barWindow
    WlrLayershell.namespace: "quickshell:bar"
    screen: Config.preferredMonitor

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 32

    color: "transparent"

    Rectangle {
        id: bar
        anchors.fill: parent

        color: Colors.bgBar

        // left
        RowLayout {
            id: barLeft

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top

            anchors.leftMargin: Config.spacing
            anchors.rightMargin: Config.spacing
            spacing: Config.spacing

            Workspaces {}
        }

        // middle
        RowLayout {
            id: barMiddle

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            anchors.leftMargin: Config.spacing
            anchors.rightMargin: Config.spacing
            spacing: Config.spacing

            Mpris {}
        }

        // right
        RowLayout {
            id: barRight

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.top: parent.top

            anchors.leftMargin: Config.spacing
            anchors.rightMargin: Config.spacing
            spacing: Config.spacing

            Tray {}
            Resources {}
            Bluetooth {}
            Battery {}
            Clock {}
        }
    }
}
