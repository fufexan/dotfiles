pragma Singleton

import QtQml
import Quickshell

Singleton {
    function getImage(image: string): string {
        if (image.search(/:\/\//) != -1)
            return Qt.resolvedUrl(image);
        return Quickshell.iconPath(image);
    }

    function humanTime(timestamp: int, elapsed: int): string {
        const MINUTE = 60;
        const HOUR = 60 * MINUTE;
        const DAY = 24 * HOUR;

        const diff = elapsed - timestamp;

        if (diff < 15) {
            return "now";
        } else if (diff < MINUTE) {
            return "seconds ago";
        } else if (diff < HOUR) {
            return `${diff}m ago`;
        } else if (diff < DAY) {
            return `${Math.round(diff / HOUR)}h ago`;
        } else if (diff < 2 * DAY) {
            return "yesterday";
        } else {
            return `${Math.round(diff / DAY)} days ago`;
        }
    }
}
