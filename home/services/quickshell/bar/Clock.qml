import QtQuick
import Quickshell
import "../components"

Text {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    text: Qt.formatDateTime(clock.date, "dddd MMM d  hh:mm")
}
