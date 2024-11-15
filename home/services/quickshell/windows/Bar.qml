import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components/bar"

Scope {
    PanelWindow {
        id: barWindow
        screen: Quickshell.screens[0]

        anchors {
            top: true
            left: true
            right: true
        }
        height: 32

        color: "transparent"

        Rectangle {
            id: bar
            anchors.fill: parent

            color: "transparent"

            // left
            RowLayout {
                id: barLeft

                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 5

                spacing: 5

                Workspaces {}
            }

            // middle
            RowLayout {
                id: barMiddle

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                spacing: 5

                Mpris {}
            }

            // right
            RowLayout {
                id: barRight

                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 5

                spacing: 5

                Tray {}
                Resources {}
                System {}
                Clock {}
            }
        }
    }
}
