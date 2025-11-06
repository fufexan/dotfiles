import "../utils/."
import "../notifications"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import org.kde.kirigami
import "../components"

ColumnLayout {
    id: root
    Layout.fillWidth: true

    WrapperRectangle {
        id: wrapper
        Layout.fillWidth: true
        margin: 4
        radius: 16
        color: Colors.bgBlur

        RowLayout {
            WrapperRectangle {
                margin: 4
                color: "transparent"
                Text {
                    text: "No notifications"
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
