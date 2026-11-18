pragma ComponentBehavior: Bound

import qs.utils
import "../notifications"
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import qs.components

ColumnLayout {
    id: root
    Layout.fillWidth: true
    // Persistent gap between the header and the list's clip edge, so scrolled
    // cards clip a little below the header instead of gluing to it.
    spacing: Config.padding

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
            useInnerStroke: true

            RowLayout {
                id: mainLayout

                anchors.fill: parent
                anchors.leftMargin: Config.spacing
                anchors.rightMargin: Config.spacing / 2

                Text {
                    text: (NotifClient.count || "No") + " notification" + (NotifClient.count != 1 ? "s" : "")
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true
                    spacing: Config.padding * 2

                    MaterialIconButton {
                        id: dndButton

                        onPressed: NotifClient.toggleDnd()
                        icon: "do_not_disturb_" + (NotifClient.doNotDisturb ? "on" : "off")
                        text: "Do not disturb " + (NotifClient.doNotDisturb ? "on" : "off")
                    }

                    IconButton {
                        id: closeButton

                        onPressed: NotifClient.closeAll()
                        icon: "process-stop-symbolic"
                        text: "Close all notifications"
                    }
                }
            }
        }
    }

    Item {
        id: notifListContainer

        Layout.fillWidth: true
        Layout.preferredHeight: Math.max(0, Math.min(notifList.contentHeight, notifList.availableHeight))

        ListView {
            id: notifList

            anchors.fill: parent
            anchors.leftMargin: -Config.padding * 5
            anchors.rightMargin: -Config.padding
            anchors.bottomMargin: -Config.padding * 4

            // Cap the list to the space left below it in the window so it scrolls
            // instead of overflowing when there are more notifications than fit.
            readonly property real availableHeight: {
                const win = QsWindow.window;
                if (!win)
                    return contentHeight;
                const top = root.parent.y + root.y + notifListContainer.y;
                return win.height - top - Config.padding * 5;
            }

            // The clip edge has to stay just below the translucent header, or scrolled
            // cards show through it. This spacer leaves the first card's top shadow
            // room inside the clip instead.
            header: Item {
                width: notifList.width
                height: Config.padding * 2
            }

            clip: true
            reuseItems: true
            spacing: Config.padding
            boundsBehavior: Flickable.StopAtBounds

            model: NotifClient.model

            delegate: Item {
                id: del

                required property int nid
                required property string summary
                required property string body
                required property string appIcon
                required property string image
                required property string timeStr
                required property string actionsJson

                width: notifList.width
                implicitHeight: box.implicitHeight

                NotificationBox {
                    id: box
                    x: Config.padding * 5
                    // The box has its own "image" property, so read roles through del.
                    n: ({
                            id: del.nid,
                            summary: del.summary,
                            body: del.body,
                            appIcon: del.appIcon,
                            image: del.image,
                            time: Number(del.timeStr),
                            actions: JSON.parse(del.actionsJson)
                        })
                    showTime: true
                    shadowBlur: Config.blurMax / 2
                    shadowSpread: Config.padding / 2
                    dismissOnClose: false

                    onActionInvoked: i => NotifClient.invokeAction(del.nid, i)
                    onCloseRequested: NotifClient.close(del.nid)
                    onCloseAllRequested: NotifClient.closeAll()
                }
            }
        }
    }
}
