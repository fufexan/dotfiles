pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import qs.components
import qs.utils

HoverTooltip {
    id: root
    required property SystemTrayItem modelData
    property point position

    text: modelData.tooltipTitle

    TrayMenu {
        id: menu
        position: root.position
        menu: root.modelData.menu
    }

    Rectangle {
        id: trayIconItem

        color: menu.visible ? Colors.buttonDisabledHover : root.containsMouse ? Colors.buttonDisabled : "transparent"
        radius: 20

        implicitWidth: trayIcon.implicitWidth + Config.padding * 2
        implicitHeight: trayIcon.implicitHeight + Config.padding * 2

        IconImage {
            id: trayIcon

            anchors.centerIn: parent

            mipmap: true
            source: root.modelData.icon
            implicitSize: Config.iconSize

            Component.onCompleted: Qt.callLater(function () {
                root.position = Qt.binding(function () {
                    let p = mapToGlobal(x, y);
                    let m = Config.preferredMonitor;
                    if (m.name != "eDP-1") {
                        p.x -= m.x;
                        p.y -= m.y;
                    }
                    return p;
                });
            })
        }

        MultiEffect {
            source: trayIcon
            anchors.fill: trayIcon
            shadowEnabled: Config.shadowEnabled
            shadowVerticalOffset: Config.shadowVerticalOffset
            blurMax: Config.blurMax
            opacity: Config.shadowOpacity
        }
    }

    acceptedButtons: Qt.RightButton | Qt.LeftButton

    onClicked: event => {
        switch (event.button) {
        case Qt.LeftButton:
            modelData.activate();
            break;
        case Qt.RightButton:
            if (modelData.hasMenu) {
                menu.visible = !menu.visible;
            }
            break;
        }
        event.accepted = true;
    }
}
