import QtQuick
import Quickshell
import Quickshell.Widgets
import "../components"
import "../utils/."

WrapperMouseArea {
    onClicked: () => NotificationState.togglePanel()

    Text {
        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
        text: Qt.formatDateTime(clock.date, "dddd MMM d  hh:mm")
    }
}
