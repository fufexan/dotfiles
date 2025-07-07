import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

WrapperRectangle {
    id: root
    resizeChild: false
    margin: 0
    color: "transparent"
    Layout.fillHeight: true

    RowLayout {
        Repeater {
            model: SystemTray.items

            WrapperMouseArea {
                id: mouseArea
                required property SystemTrayItem modelData

                Item {
                    implicitWidth: trayIcon.implicitWidth
                    implicitHeight: trayIcon.implicitHeight

                    IconImage {
                        id: trayIcon
                        source: mouseArea.modelData.icon
                        implicitSize: 16
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
