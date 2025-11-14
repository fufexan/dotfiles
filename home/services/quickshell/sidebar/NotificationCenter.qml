import "../utils/."
import "../notifications"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../components"

ColumnLayout {
    id: root
    Layout.fillWidth: true

    Item {
        Layout.fillWidth: true
        implicitHeight: wrapper.implicitHeight

        RectangularShadow {
            anchors.fill: wrapper
            radius: wrapper.radius
            offset.y: Config.padding
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        WrapperRectangle {
            id: wrapper
            implicitWidth: parent.width
            margin: Config.padding
            radius: Config.radius
            color: Colors.bgBlurShadow

            RowLayout {
                WrapperRectangle {
                    margin: Config.padding
                    leftMargin: Config.padding * 2
                    color: "transparent"
                    Text {
                        text: (NotificationState.allNotifs.length || "No") + " notification" + (NotificationState.allNotifs.length != 1 ? "s" : "")
                    }
                }

                IconButton {
                    id: closeButton
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true

                    onPressed: NotificationState.closeAll()
                    icon: "process-stop-symbolic"
                    text: "Close all notifications"
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
