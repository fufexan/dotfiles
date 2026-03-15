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

    Item {
        id: trayIconItem

        implicitWidth: trayIcon.implicitWidth
        implicitHeight: trayIcon.implicitHeight

        Component.onCompleted: Qt.callLater(function () {
            root.position = Qt.binding(function () {
                return mapToGlobal(x, y);
            });
        })

        IconImage {
            id: trayIcon

            mipmap: true
            source: root.modelData.icon
            implicitSize: Config.iconSize
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
