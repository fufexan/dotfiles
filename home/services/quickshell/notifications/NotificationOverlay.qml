import "../utils/."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    screen: Quickshell.screens.find(m => m.name === Config.preferredMonitor)
    visible: NotificationState.notifOverlayOpen

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
                required property int index
                n: NotificationState.popupNotifs[index]
                timestamp: Date.now()
                indexPopup: index

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
