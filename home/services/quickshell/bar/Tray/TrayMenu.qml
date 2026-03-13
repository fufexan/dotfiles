pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.utils

PanelWindow {
    id: root

    visible: false

    property point position
    property alias menu: opener.menu
    property var menuStack: []

    screen: Config.preferredMonitor
    color: 'transparent'

    WlrLayershell.namespace: "quickshell:popup"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    QsMenuOpener {
        id: opener
        onMenuChanged: console.log(`new menu: ${menu}, menu stack: ${JSON.stringify(root.menuStack)}`)
        // onChildrenChanged: console.log("Menu children changed, count:", children.values.length)
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.BackButton
        onClicked: event => {
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && root.menuStack.length > 0) {
                root.menu = root.menuStack.pop();
                return;
            }
            root.visible = false;
        // event.accepted();
        }
    }

    Item {
        id: menuContainer

        focus: root.visible
        Keys.onEscapePressed: root.visible = false

        x: root.position.x - bg.implicitWidth / 2
        y: root.position.y + Config.padding * 4
        implicitHeight: bg.implicitWidth
        implicitWidth: bg.implicitHeight

        RectangularShadow {
            anchors.fill: bg
            radius: bg.radius
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        Squircle {
            id: bg

            color: Colors.bgBlurShadow
            power: 3
            strokeWidth: 1
            strokeColor: Colors.border

            implicitWidth: columnLayout.implicitWidth + Config.padding * 2
            implicitHeight: columnLayout.implicitHeight + Config.padding * 2

            ColumnLayout {
                id: columnLayout

                anchors.centerIn: parent
                spacing: 0

                Repeater {
                    model: opener.children
                    delegate: TrayMenuEntry {
                        opener: opener
                        onOpenSubmenu: handle => {
                            let stack = root.menuStack;
                            stack.push(root.menu);
                            root.menuStack = stack;
                            root.menu = handle;
                        }
                    }
                }
            }
        }
    }
}
