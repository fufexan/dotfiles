pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: persist.brightness

    PersistentProperties {
        id: persist
        reloadableId: "persistedBrightness"
        property string screenInterface: ""
        readonly property string path: `/sys/class/backlight/${screenInterface}`
        readonly property int rawBrightness: Number(getRawBrightness.text());
        readonly property int max: Number(getMaxBrightness.text());
        readonly property real brightness: rawBrightness / max;
    }

    Process {
        id: getScreenInterface

        running: true
        command: ["sh", "-c", "ls -w1 /sys/class/backlight | head -1"]
        stdout: SplitParser {
            onRead: data => {
                persist.screenInterface = data;
            }
        }
    }

    FileView {
        id: getMaxBrightness
        path: `${persist.path}/max_brightness`
        blockLoading: true
    }

    FileView {
        id: getRawBrightness
        path: `${persist.path}/brightness`
        blockLoading: true

        watchChanges: true
        onFileChanged: this.reload()
    }
}
