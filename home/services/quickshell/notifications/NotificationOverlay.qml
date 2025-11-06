pragma ComponentBehavior: Bound

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

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:notifications:overlay"

    implicitWidth: 360

    color: "transparent"
    mask: Region {
        item: notifs
    }

    anchors {
        top: true
        right: true
        bottom: true
    }

    margins {
        top: Config.barHeight + 8
        right: 8
        bottom: 8
    }

    ColumnLayout {
        id: notifs

        Repeater {
            model: NotificationState.popupNotifs

            NotificationBox {
                id: notifBox
                required property Notification modelData
                n: modelData

                Timer {
                    running: root.visible
                    interval: (notifBox.n.expireTimeout > 0 ? notifBox.n.expireTimeout : Config.notificationExpireTimeout) * 1000
                    onTriggered: {
                        NotificationState.notifDismissByNotif(notifBox.n);
                    }
                }
            }
        }
    }
}
