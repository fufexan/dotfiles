import qs.utils
import "../notifications"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.components

ColumnLayout {
    id: root
    Layout.fillWidth: true

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

    ColumnLayout {
        id: notifs

        Repeater {
            id: notifRepeater
            model: NotificationState.allNotifs

            NotificationBox {
                id: notifBox
                required property Notification modelData
                n: modelData
                showTime: true
                dismissOnClose: false
            }
        }
    }
}
