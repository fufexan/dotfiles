import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../components"
import "../utils/."

WrapperRectangle {
    id: root
    resizeChild: false
    color: "transparent"

    RowLayout {
        Repeater {
            model: SystemTray.items

            HoverTooltip {
                id: mouseArea
                required property SystemTrayItem modelData

                text: modelData.tooltipTitle

                Item {
                    implicitWidth: trayIcon.implicitWidth
                    implicitHeight: trayIcon.implicitHeight

                    IconImage {
                        id: trayIcon
                        mipmap: true
                        source: mouseArea.modelData.icon
                        implicitSize: Config.iconSize
                    }
                }

                acceptedButtons: Qt.RightButton | Qt.LeftButton

                onClicked: event => {
                    switch (event.button) {
                    case Qt.LeftButton:
                        modelData.activate();
                        break;
                    case Qt.RightButton:
                        if (modelData.hasMenu)
                            menu.open();
                        break;
                    }
                    event.accepted = true;
                }

                QsMenuAnchor {
                    id: menu
                    menu: mouseArea.modelData.menu
                    onVisibleChanged: QsWindow.window.inhibitGrab = visible

                    anchor {
                        item: trayIcon
                        edges: Edges.Right | Edges.Top
                        gravity: Edges.Left | Edges.Bottom
                        adjustment: PopupAdjustment.All
                    }
                }
            }
        }
    }
}
