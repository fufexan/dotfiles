pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs.utils
import qs.components

WrapperMouseArea {
    id: root

    acceptedButtons: Qt.AllButtons
    hoverEnabled: true

    property Notification n
    property int elapsed: getElapsed()
    property string image: !n.image && !!n.appIcon ? n.appIcon : n.image
    property bool hasAppIcon: !!n.image && !!n.appIcon
    property real iconSize: Config.notificationIconSize

    property bool showTime: false
    property bool expanded: true

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
        implicitWidth: mainRect.width
        implicitHeight: mainRect.height

        RectangularShadow {
            anchors.fill: mainRect
            radius: mainRect.radius
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        Squircle {
            id: mainRect
            color: Colors.bgBlur
            strokeWidth: 1.0
            strokeColor: Colors.border
            implicitWidth: Config.notificationWidth
            implicitHeight: mainLayout.height

            RowLayout {
                id: mainLayout

                spacing: Config.padding * 2

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
                    Layout.margins: Config.spacing
                    Layout.rightMargin: 0

                    Squircle {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        radius: 8
                        color: "transparent"

                        content: Loader {
                            active: !!root.image
                            sourceComponent: IconImage {
                                implicitSize: coverItem.height
                                source: Utils.getImage(root.image)
                            }
                        }
                    }

                    Squircle {
                        visible: root.hasAppIcon

                        anchors {
                            horizontalCenter: coverItem.right
                            verticalCenter: coverItem.bottom
                            horizontalCenterOffset: -Config.padding
                            verticalCenterOffset: -Config.padding
                        }

                        radius: 2
                        color: "transparent"

                        width: Config.radius
                        height: Config.radius

                        content: Loader {
                            active: root.hasAppIcon
                            sourceComponent: IconImage {
                                implicitSize: Config.radius
                                source: Utils.getImage(root.n?.appIcon)
                            }
                        }
                    }
                }

                ColumnLayout {
                    id: contentLayout

                    Layout.fillWidth: true
                    Layout.maximumWidth: !!root.image ? mainLayout.width - coverItem.width - Config.spacing * 2 : mainLayout.width
                    Layout.margins: Config.spacing
                    Layout.leftMargin: coverItem.visible ? Config.padding : Config.spacing
                    spacing: Config.padding

                    RowLayout {
                        Layout.maximumWidth: contentLayout.width
                        Layout.fillWidth: false

                        Text {
                            text: root.n?.summary
                            elide: Text.ElideRight
                            Layout.fillWidth: false
                            Layout.maximumWidth: contentLayout.width
                            maximumLineCount: 1
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

            IconButton {
                id: closeButton
                visible: root.containsMouse
                enabled: root.containsMouse

                color: Colors.bgBlurShadow
                hoverColor: Colors.bgBlur

                anchors {
                    horizontalCenter: mainRect.left
                    verticalCenter: mainRect.top
                    horizontalCenterOffset: 1.5 * Config.padding
                    verticalCenterOffset: 1.5 * Config.padding
                }

                icon: "process-stop-symbolic"
                text: ""

                onPressed: NotificationState.notifCloseByNotif(root.n)
            }
        }
    }
}
