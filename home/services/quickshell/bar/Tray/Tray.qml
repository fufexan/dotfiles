import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.utils

WrapperRectangle {
    id: root
    resizeChild: false
    color: "transparent"

    RowLayout {
        spacing: Config.spacing

        Repeater {
            model: SystemTray.items

            TrayItem {}
        }
    }
}
