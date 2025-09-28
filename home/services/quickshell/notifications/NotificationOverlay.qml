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
                required property int index
                appIcon: NotificationState.popupNotifs[index].appIcon
                app: NotificationState.popupNotifs[index].appName
                summary: NotificationState.popupNotifs[index].summary
                body: NotificationState.popupNotifs[index].body
                icon: NotificationState.popupNotifs[index].appIcon
                actions: NotificationState.popupNotifs[index].actions
                indexPopup: index
            }
        }
    }
}
