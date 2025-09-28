pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import org.kde.kirigami
import "../utils/."
import "../components"

WrapperMouseArea {
    id: root

    acceptedButtons: Qt.AllButtons

    property Notification n
    property string image: (n.image == "" && n.appIcon != "") ? n.appIcon : n.image
    property bool hasAppIcon: !(n.image == "" && n.appIcon != "")
    property int indexPopup: -1
    property int indexAll: -1
    property real iconSize: 48
    property bool expanded: false

    function getImage(image: string): string {
        if (image.search(/:\/\//) != -1)
            return Qt.resolvedUrl(image);
        return Quickshell.iconPath(image);
    }

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton && root.n.actions != []) {
            root.n.actions[0].invoke();
        } else if (mouse.button == Qt.RightButton) {
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

            spacing: 8

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Item {
                id: coverItem

                visible: root.image != ""

                Layout.alignment: Qt.AlignTop
                implicitWidth: root.iconSize
                implicitHeight: root.iconSize
                Layout.margins: 12
                Layout.rightMargin: 0

                ClippingWrapperRectangle {
                    anchors.centerIn: parent
                    radius: 8
                    color: "transparent"

                    IconImage {
                        implicitSize: coverItem.height
                        source: root.getImage(root.image)
                    }
                }

                ClippingWrapperRectangle {
                    visible: root.hasAppIcon

                    anchors {
                        horizontalCenter: coverItem.right
                        verticalCenter: coverItem.bottom
                        horizontalCenterOffset: -4
                        verticalCenterOffset: -4
                    }

                    radius: 2
                    color: "transparent"

                    IconImage {
                        implicitSize: 16
                        source: root.getImage(root.n.appIcon)
                    }
                }
            }

            ColumnLayout {
                id: contentLayout

                Layout.fillWidth: true
                Layout.margins: 12
                Layout.leftMargin: coverItem.visible ? 4 : 12
                spacing: 4

                Text {
                    Layout.maximumWidth: contentLayout.width - buttonLayout.width
                    text: root.n.summary
                    elide: Text.ElideRight
                    font.weight: Font.Bold
                }

                Text {
                    id: bodyText
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.weight: Font.Medium
                    maximumLineCount: root.expanded ? 5 : (root.n.actions.length > 1 ? 1 : 2)
                    text: root.n.body
                }

                RowLayout {
                    visible: root.n.actions.length > 1

                    Layout.fillWidth: true
                    implicitHeight: actionRepeater.implicitHeight

                    Repeater {
                        id: actionRepeater
                        model: root.n.actions.slice(1)

                        WrapperMouseArea {
                            id: actionButtonMA
                            required property NotificationAction modelData

                            hoverEnabled: true
                            implicitHeight: actionButton.implicitHeight
                            Layout.fillWidth: true

                            onPressed: () => {
                                modelData.invoke();
                            }

                            Rectangle {
                                id: actionButton

                                radius: 16
                                color: actionButtonMA.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                                implicitHeight: buttonText.implicitHeight
                                Layout.fillWidth: true

                                Text {
                                    id: buttonText

                                    anchors.centerIn: parent
                                    text: actionButtonMA.modelData.text
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            id: buttonLayout
            implicitHeight: 16

            anchors {
                top: parent.top
                right: parent.right
                topMargin: 8
                rightMargin: 8
            }

            WrapperMouseArea {
                id: expandButton

                visible: bodyText.text.length > (root.n.actions.length > 1 ? 50 : 100)

                property string sourceIcon: root.expanded ? "go-up-symbolic" : "go-down-symbolic"

                hoverEnabled: true
                Layout.fillHeight: true
                implicitWidth: 16

                onPressed: () => root.expanded = !root.expanded

                Rectangle {
                    radius: 16
                    color: expandButton.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                    implicitWidth: 16
                    implicitHeight: 16

                    Icon {
                        source: Quickshell.iconPath(expandButton.sourceIcon)
                        anchors.centerIn: parent
                        implicitHeight: parent.implicitHeight - 4
                        implicitWidth: parent.implicitHeight - 4
                        isMask: true
                        color: Colors.foreground
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
                    color: closeButton.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
                    implicitWidth: 16
                    implicitHeight: 16

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
}
