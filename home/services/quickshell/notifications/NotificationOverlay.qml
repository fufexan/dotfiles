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
    visible: NotificationState.notifOverlayOpen && !NotificationState.showSidebar && !NotificationState.doNotDisturb

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
            // Render only the newest few cards. Older ones stay queued in popupNotifs
            // and appear as visible ones expire, so none are lost during a burst.
            model: Math.min(NotificationState.popupNotifs.length, 5)

            NotificationBox {
                id: notifBox
                required property int index
                n: NotificationState.popupNotifs[index]

                onActionInvoked: i => notifBox.n?.actions[i]?.invoke()
                onDismissRequested: NotificationState.notifDismissByNotif(notifBox.n)
                onCloseRequested: NotificationState.notifCloseByNotif(notifBox.n)
                onDismissAllRequested: NotificationState.dismissAll()
                onCloseAllRequested: NotificationState.closeAll()

                Timer {
                    running: root.visible && !!notifBox.n
                    interval: (notifBox.n?.expireTimeout ?? 0) > 0 ? notifBox.n.expireTimeout : Config.notificationExpireTimeout
                    onTriggered: {
                        if (notifBox.n)
                            NotificationState.notifDismissByNotif(notifBox.n);
                    }
                }
            }
        }
    }
}
