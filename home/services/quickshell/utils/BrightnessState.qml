pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: persist.brightness
    property bool interfaceReady: false

    PersistentProperties {
        id: persist
        reloadableId: "persistedBrightness"
        property string screenInterface: ""
        readonly property string path: `/sys/class/backlight/${screenInterface}`
        readonly property int rawBrightness: screenInterface !== "" ? Number(getRawBrightness.text()) : 0
        readonly property int max: screenInterface !== "" ? Number(getMaxBrightness.text()) : 1
        readonly property real brightness: max > 0 ? rawBrightness / max : 0
    }

    Process {
        id: getScreenInterface

        running: true
        command: ["sh", "-c", "ls -w1 /sys/class/backlight | head -1"]
        stdout: SplitParser {
            onRead: data => {
                persist.screenInterface = data.trim();
                root.interfaceReady = true;
            }
        }
    }

    FileView {
        id: getMaxBrightness
        path: !!persist.screenInterface && root.interfaceReady ? `${persist.path}/max_brightness` : ""
        blockLoading: true
    }

    FileView {
        id: getRawBrightness
        path: !!persist.screenInterface && root.interfaceReady ? `${persist.path}/brightness` : ""
        blockLoading: true

        watchChanges: true
        onFileChanged: this.reload()
    }
}
