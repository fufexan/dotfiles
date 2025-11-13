pragma Singleton

import QtQml
import Quickshell

Singleton {
    function getImage(image: string): string {
        if (image.search(/:\/\//) != -1)
            return Qt.resolvedUrl(image);
        return Quickshell.iconPath(image);
    }

    function humanTime(elapsed: int): string {
        const MINUTE = 60;
        const HOUR = 60 * MINUTE;
        const DAY = 24 * HOUR;

        if (elapsed < 15) {
            return "now";
        } else if (elapsed < MINUTE) {
            return "seconds ago";
        } else if (elapsed < HOUR) {
            return `${Math.round(elapsed / MINUTE)}m ago`;
        } else if (elapsed < DAY) {
            return `${Math.round(elapsed / HOUR)}h ago`;
        } else if (elapsed < 2 * DAY) {
            return "yesterday";
        } else {
            return `${Math.round(elapsed / DAY)} days ago`;
        }
    }

    property var clock: SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
