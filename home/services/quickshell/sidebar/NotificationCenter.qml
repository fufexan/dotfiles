pragma ComponentBehavior: Bound

import qs.utils
import "../notifications"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import qs.components

ColumnLayout {
    id: root
    Layout.fillWidth: true
    // Persistent gap between the header and the list's clip edge, so scrolled
    // cards clip a little below the header instead of gluing to it.
    spacing: Config.padding

    Item {
        Layout.fillWidth: true
        implicitHeight: wrapper.implicitHeight

        RectangularShadow {
            anchors.fill: wrapper
            radius: wrapper.radius
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        Squircle {
            id: wrapper
            implicitWidth: parent.width
            implicitHeight: mainLayout.implicitHeight + Config.padding * 3
            power: 2
            color: Colors.bgBlurShadow
            strokeColor: Colors.border
            strokeWidth: 1
            useInnerStroke: true

            RowLayout {
                id: mainLayout

                anchors.fill: parent
                anchors.leftMargin: Config.spacing
                anchors.rightMargin: Config.spacing / 2

                Text {
                    text: (NotificationState.allNotifs.length || "No") + " notification" + (NotificationState.allNotifs.length != 1 ? "s" : "")
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true
                    spacing: Config.padding * 2

                    MaterialIconButton {
                        id: dndButton

                        onPressed: Config.doNotDisturb = !Config.doNotDisturb
                        icon: "do_not_disturb_" + (Config.doNotDisturb ? "on" : "off")
                        text: "Do not disturb " + (Config.doNotDisturb ? "on" : "off")
                    }

                    IconButton {
                        id: closeButton

                        onPressed: NotificationState.closeAll()
                        icon: "process-stop-symbolic"
                        text: "Close all notifications"
                    }
                }
            }
        }
    }

    Item {
        id: notifListContainer

        Layout.fillWidth: true
        Layout.preferredHeight: Math.max(0, Math.min(notifList.contentHeight, notifList.availableHeight))

        ListView {
            id: notifList

            anchors.fill: parent
            anchors.leftMargin: -Config.padding * 5
            anchors.rightMargin: -Config.padding
            anchors.bottomMargin: -Config.padding * 4

            // Cap the list to the space left below it in the window so it scrolls
            // instead of overflowing when there are more notifications than fit.
            readonly property real availableHeight: {
                const win = QsWindow.window;
                if (!win)
                    return contentHeight;
                const top = root.parent.y + root.y + notifListContainer.y;
                return win.height - top - Config.padding * 5;
            }

            clip: true
            reuseItems: true
            spacing: Config.padding
            boundsBehavior: Flickable.StopAtBounds

            model: NotificationState.allNotifs.length

            delegate: Item {
                required property int index
                width: notifList.width
                implicitHeight: box.implicitHeight

                NotificationBox {
                    id: box
                    x: Config.padding * 5
                    n: NotificationState.allNotifs[index]
                    showTime: true
                    dismissOnClose: false
                }
            }
        }
    }
}
