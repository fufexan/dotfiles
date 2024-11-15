pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property var locale: Qt.locale()

    function createDate(): string {
        let date = new Date();
        let hh = date.getHours().toString().padStart(2, 0);
        let mm = date.getMinutes().toString().padStart(2, 0)
        let weekday = locale.dayName(date.getDay(), Locale.ShortFormat)
        let month = locale.monthName(date.getMonth(), Locale.ShortFormat)
        let day = date.getDate()

        return `${weekday} ${month} ${day}  ${hh}:${mm}`
    }

    property var time: createDate()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: time = createDate()
    }
}
