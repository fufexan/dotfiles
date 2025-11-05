import "../utils/."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    id: root

    screen: Config.preferredMonitor
    visible: NotificationState.notifOverlayOpen && !Config.showSidebar

    WlrLayershell.namespace: "quickshell:notifications:overlay"
    WlrLayershell.layer: WlrLayer.Top

    implicitHeight: notifs.height
    implicitWidth: notifs.width + 10

    color: "transparent"

    anchors {
        top: true
        right: true
    }

    ColumnLayout {
        id: notifs

        Item {
            implicitHeight: 10
        }

        Repeater {
            model: NotificationState.popupNotifs

            NotificationBox {
                id: notifBox
                required property Notification modelData
                n: modelData

                Timer {
                    running: true
                    interval: (notifBox.n.expireTimeout > 0 ? notifBox.n.expireTimeout : Config.notificationExpireTimeout) * 1000
                    onTriggered: {
                        NotificationState.notifDismissByNotif(notifBox.n);
                    }
                }
            }
        }
    }
}
