pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "../utils/."
import "../components"

WrapperMouseArea {
    id: root

    acceptedButtons: Qt.AllButtons
    hoverEnabled: true

    property Notification n
    property int elapsed: getElapsed()
    property string image: (n.image == "" && n.appIcon != "") ? n.appIcon : n.image
    property bool hasAppIcon: !(n.image == "" && n.appIcon != "")
    property real iconSize: 48

    property bool showTime: false
    property bool expanded: false

    property bool dismissOnClose: true

    function getElapsed(): int {
        return Math.floor(Date.now() / 1000) - Math.floor(n.time / 1000);
    }

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton && root.n?.actions != []) {
            root.n?.actions[0].invoke();
        } else if (mouse.button == Qt.RightButton) {
            if (dismissOnClose) {
                NotificationState.notifDismissByNotif(n);
            } else {
                NotificationState.notifCloseByNotif(n);
            }
        } else if (mouse.button == Qt.MiddleButton && dismissOnClose) {
            NotificationState.dismissAll();
        } else if (mouse.button == Qt.MiddleButton) {
            NotificationState.closeAll();
        }
    }

    Timer {
        running: root.showTime
        interval: 1000
        repeat: true
        onTriggered: root.elapsed = root.getElapsed()
    }

    Item {
        implicitWidth: mainRect.implicitWidth
        implicitHeight: mainRect.implicitHeight

        RectangularShadow {
            anchors.fill: mainRect
            radius: mainRect.radius
            offset.y: Config.padding
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        Rectangle {
            id: mainRect

            implicitWidth: 360
            implicitHeight: mainLayout.implicitHeight
            radius: Config.radius
            color: Colors.bgBlurShadow

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
                            source: Utils.getImage(root.image)
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
                            source: Utils.getImage(root.n?.appIcon)
                        }
                    }
                }

                ColumnLayout {
                    id: contentLayout

                    Layout.fillWidth: true
                    Layout.margins: 12
                    Layout.leftMargin: coverItem.visible ? 4 : 12
                    spacing: 4

                    RowLayout {
                        Layout.maximumWidth: contentLayout.width - buttonLayout.width
                        Layout.fillWidth: false

                        Text {
                            text: root.n?.summary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            maximumLineCount: 1
                            wrapMode: Text.Wrap
                            font.weight: Font.Bold
                        }

                        Text {
                            visible: root?.showTime
                            text: "·"
                        }

                        Text {
                            visible: root?.showTime
                            text: Utils.humanTime(root.elapsed)
                        }
                    }

                    Text {
                        id: bodyText
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        wrapMode: Text.Wrap
                        font.weight: Font.Medium
                        maximumLineCount: root.expanded ? 5 : (root.n?.actions.length > 1 ? 1 : 2)
                        text: root.n?.body
                    }

                    RowLayout {
                        visible: root.n?.actions.length > 1

                        Layout.fillWidth: true
                        implicitHeight: actionRepeater.implicitHeight

                        Repeater {
                            id: actionRepeater
                            model: root.n?.actions.slice(1)

                            Button {
                                id: actionButtonMA
                                required property NotificationAction modelData

                                Layout.fillWidth: true

                                buttonText: actionButtonMA.modelData.text
                                text: ""
                                onPressed: modelData.invoke()
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: buttonLayout
                visible: root.containsMouse
                implicitHeight: 16

                anchors {
                    top: parent.top
                    right: parent.right
                    topMargin: 8
                    rightMargin: 8
                }

                IconButton {
                    id: expandButton

                    Layout.fillHeight: true
                    Layout.minimumHeight: 16
                    visible: bodyText.text.length > (root.n?.actions.length > 1 ? 50 : 100)

                    icon: root.expanded ? "go-up-symbolic" : "go-down-symbolic"
                    text: ""

                    onPressed: () => root.expanded = !root.expanded
                }

                IconButton {
                    id: closeButton
                    Layout.minimumHeight: 16

                    Layout.fillHeight: true

                    icon: "process-stop-symbolic"
                    text: ""

                    onPressed: NotificationState.notifCloseByNotif(root.n)
                }
            }
        }
    }
}
