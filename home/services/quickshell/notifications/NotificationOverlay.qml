pragma ComponentBehavior: Bound

import qs.utils
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    id: root

    screen: Config.preferredMonitor
    visible: NotificationState.notifOverlayOpen && !Config.showSidebar && !Config.doNotDisturb

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:notifications:overlay"

    implicitWidth: Config.notificationWidth + Config.padding * 6

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
        top: Config.barHeight
    }

    ColumnLayout {
        id: notifs

        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            leftMargin: Config.padding * 5
            rightMargin: Config.padding * 4
            topMargin: Config.padding
        }

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
