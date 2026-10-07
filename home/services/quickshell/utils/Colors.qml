pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool darkMode: true

    function apply(value: string): void {
        if (value.includes("prefer-light"))
            root.darkMode = false;
        else if (value.includes("prefer-dark"))
            root.darkMode = true;
    }

    // initial value on (re)load
    Process {
        running: true
        command: ["dconf", "read", "/org/gnome/desktop/interface/color-scheme"]
        stdout: StdioCollector {
            onStreamFinished: root.apply(text)
        }
    }

    // live updates when the preference changes
    Process {
        running: true
        command: ["dconf", "watch", "/org/gnome/desktop/interface/color-scheme"]
        stdout: SplitParser {
            onRead: data => root.apply(data)
        }
    }

    readonly property color bgBar: darkMode ? Qt.rgba(0, 0, 0, 0.21) : Qt.hsla(0, 0, 0.95, 0.11)
    readonly property color bgBlur: darkMode ? Qt.rgba(0, 0, 0, 0.5) : Qt.hsla(0, 0, 0.95, 0.5)
    readonly property color bgBlurShadow: darkMode ? Qt.rgba(0, 0, 0, 0.4) : Qt.hsla(0, 0, 0.95, 0.4)
    readonly property color bg: darkMode ? Qt.rgba(0, 0, 0, 0.9) : Qt.hsla(0, 0, 0.95, 0.9)
    readonly property color foreground: darkMode ? Qt.hsla(0, 0, 0.95, 1) : Qt.hsla(0, 0, 0.05, 1)
    readonly property color foregroundOSD: Qt.hsla(0, 0, 0.95, 0.7)
    readonly property color windowShadow: Qt.rgba(0, 0, 0, 0.2)
    readonly property list<color> monitorColors: ["#e06c75", "#e5c07b", "#98c379", "#61afef"]
    // readonly property list<color> monitorColors: darkMode ? ["#e06c75", "#e5c07b", "#98c379", "#61afef"] : ["#D50000", "#FF6F00", "#24A443", "#0061FF"]

    readonly property color surface: darkMode ? Qt.hsla(0, 0, 0.95, 0.15) : Qt.hsla(0, 0, 0.05, 0.15)
    readonly property color overlay: darkMode ? Qt.hsla(0, 0, 0.95, 0.7) : Qt.hsla(0, 0, 0.05, 0.7)
    readonly property color border: darkMode ? Colors.bgBlur : Qt.hsla(0, 0, 0.05, 0.1)
    readonly property color innerBorder: darkMode ? Qt.hsla(0, 0, 1, 0.2) : "transparent"
    readonly property color osdBorder: darkMode ? Qt.hsla(0, 0, 0.95, 0.1) : "transparent"

    readonly property color accent: "#e06c75"

    readonly property color buttonEnabled: accent
    readonly property color buttonEnabledHover: Qt.lighter(accent, 0.9)
    readonly property color buttonDisabled: surface
    readonly property color buttonDisabledHover: Qt.rgba(surface.r, surface.g, surface.b, surface.a + 0.1)
}
