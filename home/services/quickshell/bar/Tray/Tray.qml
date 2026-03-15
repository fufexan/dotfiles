import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.utils

RowLayout {
    spacing: Config.padding

    Repeater {
        model: SystemTray.items

        TrayItem {}
    }
}
