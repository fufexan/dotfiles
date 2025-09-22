import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import org.kde.kirigami
import "../utils/."
import "../components"

WrapperMouseArea {
    id: root

    acceptedButtons: Qt.AllButtons

    property string appIcon: ""
    property string app: ""
    property string summary: ""
    property string body: ""
    property string icon: ""
    property int indexPopup: -1
    property int indexAll: -1
    property bool hasDismiss: true
    property real iconSize: 48
    property bool expanded: false

    onClicked: mouse => {
        if (mouse.button == Qt.RightButton) {
            if (indexAll != -1)
                NotificationState.notifDismissByAll(indexAll);
            else if (indexPopup != -1)
                NotificationState.notifDismissByPopup(indexPopup);
        } else if (mouse.button == Qt.MiddleButton) {
            NotificationState.dismissAll();
        }
    }

    Rectangle {
        implicitWidth: 360
        implicitHeight: mainLayout.implicitHeight
        radius: 16
        color: Colors.bgBlur

        RowLayout {
            id: mainLayout

            implicitHeight: contentLayout.implicitHeight
            spacing: 8

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Item {
                id: coverItem

                visible: root.icon != ""

                Layout.alignment: Qt.AlignTop
                implicitWidth: root.iconSize
                implicitHeight: root.iconSize
                Layout.margins: 8
                Layout.rightMargin: 0

                ClippingWrapperRectangle {
                    visible: root.icon != ""
                    anchors.centerIn: parent
                    radius: 8
                    color: "transparent"

                    IconImage {
                        implicitSize: coverItem.height
                        source: Quickshell.iconPath(root.icon)
                    }
                }
            }

            ColumnLayout {
                id: contentLayout

                Layout.fillWidth: true
                Layout.margins: 15
                Layout.leftMargin: coverItem.visible ? 0 : 15
                spacing: 5

                Text {
                    Layout.maximumWidth: contentLayout.width - buttonLayout.width
                    text: root.summary
                    elide: Text.ElideRight
                }

                Text {
                    id: bodyText
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: root.expanded ? 5 : 1
                    text: root.body
                }
            }
        }

        RowLayout {
            id: buttonLayout
            implicitHeight: 16

            anchors {
                top: parent.top
                right: parent.right
                topMargin: 13
                rightMargin: 12
            }

            WrapperMouseArea {
                id: expandButton

                visible: bodyText.truncated

                property string sourceIcon: "go-down-symbolic"

                hoverEnabled: true
                Layout.fillHeight: true
                implicitWidth: 16

                onPressed: () => {
                    root.expanded = !root.expanded;
                    sourceIcon = root.expanded ? "go-up-symbolic" : "go-down-symbolic";
                }

                Rectangle {
                    radius: 16
                    color: expandButton.containsMouse ? Colors.bgBar : Colors.bgBlur
                    implicitWidth: 16
                    implicitHeight: 16

                    Icon {
                        source: Quickshell.iconPath(expandButton.sourceIcon)
                        anchors.centerIn: parent
                        implicitHeight: parent.implicitHeight - 4
                        implicitWidth: parent.implicitHeight - 4
                        isMask: true
                        color: 'white'
                    }
                }
            }

            WrapperMouseArea {
                id: closeButton

                hoverEnabled: true
                Layout.fillHeight: true
                implicitWidth: 16

                onPressed: () => {
                    if (root.indexAll != -1)
                        NotificationState.notifCloseByAll(root.indexAll);
                    else if (root.indexPopup != -1)
                        NotificationState.notifCloseByPopup(root.indexPopup);
                }

                Rectangle {
                    radius: 16
                    color: closeButton.containsMouse ? Qt.lighter(Qt.lighter(Qt.lighter(Colors.bgBlur))) : Qt.lighter(Qt.lighter(Colors.bgBlur))
                    implicitWidth: 16
                    implicitHeight: 16

                    Icon {
                        source: Quickshell.iconPath("process-stop-symbolic")
                        anchors.centerIn: parent
                        implicitHeight: parent.implicitHeight - 4
                        implicitWidth: parent.implicitHeight - 4
                        isMask: true
                        color: 'white'
                    }
                }
            }
        }
    }
}
