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

            WrapperMouseArea {
                id: closeButton
                Layout.alignment: Qt.AlignRight

                hoverEnabled: true
                Layout.fillHeight: true
                implicitWidth: height

                onPressed: () => {
                    NotificationState.closeAll();
                }

                Rectangle {
                    radius: closeButton.implicitWidth
                    color: closeButton.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                    implicitWidth: radius
                    implicitHeight: radius

                    Icon {
                        source: Quickshell.iconPath("process-stop-symbolic")
                        anchors.centerIn: parent
                        implicitHeight: parent.implicitHeight - 4
                        implicitWidth: parent.implicitHeight - 4
                        isMask: true
                        color: Colors.foreground
                    }
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
