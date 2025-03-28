//@ pragma NativeTextRendering

import Quickshell
import QtQuick
import QtQuick.Layouts
import "../utils"
import "../components/bar"
import "../components/bar/workspaces"

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

            color: Colors.bgBlur

            // left
            RowLayout {
                id: barLeft

                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.top: parent.top

                anchors.leftMargin: height / 4
                anchors.rightMargin: height / 4
                spacing: height / 4

                Workspaces {}
            }

            // middle
            RowLayout {
                id: barMiddle

                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                anchors.leftMargin: height / 4
                anchors.rightMargin: height / 4
                spacing: height / 4

                Mpris {}
            }

            // right
            RowLayout {
                id: barRight

                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.top: parent.top

                anchors.leftMargin: height / 4
                anchors.rightMargin: height / 4
                spacing: height / 4

                Tray {}
                Resources {}
                Battery {}
                Clock {}
            }
        }
    }
}
