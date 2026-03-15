pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
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
    property QsMenuHandle menu

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

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.BackButton
        onClicked: event => {
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && stack.depth > 1) {
                stack.pop();
                return;
            }
            root.visible = false;
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

            implicitWidth: stack.implicitWidth + Config.padding * 2
            implicitHeight: stack.implicitHeight + Config.padding * 2

            StackView {
                id: stack

                clip: true
                anchors.centerIn: parent

                implicitWidth: currentItem.implicitWidth
                implicitHeight: currentItem.implicitHeight

                initialItem: SubMenu {
                    handle: root.menu
                }

                property int duration: 200

                Component {
                    id: subMenuComp

                    SubMenu {}
                }
            }
        }
    }

    component SubMenu: ColumnLayout {
        id: columnLayout

        property alias handle: opener.menu
        property bool isSubMenu: false
        property bool shown

        opacity: shown ? 1 : 0

        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()

        spacing: 0

        QsMenuOpener {
            id: opener
        }

        Loader {
            active: columnLayout.isSubMenu
            Layout.fillWidth: true

            sourceComponent: Squircle {
                id: backButton

                color: backMouseArea.containsMouse ? Colors.surface : "transparent"
                radius: 10

                implicitHeight: rowLayout.implicitHeight + Config.padding * 2
                implicitWidth: rowLayout.implicitWidth + Config.padding * 2

                MouseArea {
                    id: backMouseArea
                    onClicked: stack.pop()
                    anchors.fill: parent
                    hoverEnabled: true
                }

                RowLayout {
                    id: rowLayout

                    spacing: Config.padding

                    anchors.fill: parent
                    anchors.leftMargin: Config.padding

                    Item {
                        implicitWidth: Config.iconSize
                        MaterialIcon {
                            anchors.centerIn: parent
                            text: "chevron_left"
                            font.pointSize: Config.textSize
                            font.weight: Font.DemiBold
                        }
                    }
                    Text {
                        text: "Back"
                        Layout.fillWidth: true
                        Layout.leftMargin: Config.padding * 0.5
                        Layout.rightMargin: Config.padding * 0.5
                    }
                }
            }
        }

        Repeater {
            model: opener.children
            delegate: TrayMenuEntry {
                opener: opener
                onOpenSubmenu: handle => {
                    stack.push(subMenuComp.createObject(null, {
                        handle: handle,
                        isSubMenu: true
                    }));
                }
            }
        }
    }
}
