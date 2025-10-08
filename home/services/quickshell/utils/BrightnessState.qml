pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: persist.brightness

    PersistentProperties {
        id: persist
        property string screenInterface: ""
        property string path: `/sys/class/backlight/${screenInterface}`
        property int rawBrightness: Number(getRawBrightness.text());
        property int max: Number(getMaxBrightness.text());
        property real brightness: rawBrightness / max;
    }

    Process {
        id: getScreenInterface

        running: true
        command: ["sh", "-c", "ls -w1 /sys/class/backlight | head -1"]
        stdout: SplitParser {
            onRead: data => {
                console.log(`found brightness interface ${data}`);
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
