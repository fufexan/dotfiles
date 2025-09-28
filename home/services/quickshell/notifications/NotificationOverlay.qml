import "../utils/."
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

WlrLayershell {
    id: root

    visible: NotificationState.notifOverlayOpen
    color: "transparent"
    namespace: "quickshell:notifications:overlay"
    layer: WlrLayer.Top
    implicitHeight: notifs.height
    implicitWidth: notifs.width + 10

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
