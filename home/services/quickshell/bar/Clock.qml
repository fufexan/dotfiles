import QtQuick
import Quickshell
import Quickshell.Widgets
import "../components"
import "../utils/."

WrapperMouseArea {
    onClicked: () => Config.showSidebar = !Config.showSidebar

    Text {
        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
        text: Qt.formatDateTime(clock.date, "ddd MMM d  hh:mm")
    }
}
