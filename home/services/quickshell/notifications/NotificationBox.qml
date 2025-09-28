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

    property string appIcon: ""
    property string app: ""
    property string summary: ""
    property string body: ""
    property string icon: ""
    property list<NotificationAction> actions: []
    property int indexPopup: -1
    property int indexAll: -1
    property bool hasDismiss: true
    property real iconSize: 48
    property bool expanded: false

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton && actions != []) {
            actions[0].invoke();
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
                Layout.fillHeight: true
                Layout.margins: 8
                Layout.leftMargin: coverItem.visible ? 0 : 8
                spacing: 4

                // HACK: gives the illusion that 2-row text is centered (when bodyText is only one
                // row, and no action buttons are present)
                Item {
                    Layout.fillHeight: true
                }

                Text {
                    Layout.maximumWidth: contentLayout.width - buttonLayout.width
                    text: root.summary
                    elide: Text.ElideRight
                    font.weight: Font.Bold
                }

                Text {
                    id: bodyText
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.weight: Font.Medium
                    maximumLineCount: root.expanded ? 5 : (root.actions.length > 1 ? 1 : 2)
                    text: root.body
                }

                RowLayout {
                    visible: root.actions.length > 1

                    Layout.fillWidth: true
                    implicitHeight: actionRepeater.implicitHeight

                    Repeater {
                        id: actionRepeater
                        model: root.actions.slice(1)

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

                visible: bodyText.text.length > (root.actions.length > 1 ? 50 : 100)

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
