pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property var currentColorScheme: Application.styleHints.colorScheme

    Connections {
        target: Application.styleHints

        // function onColorSchemeChanged(scheme) {
        //     console.log("Color scheme changed to", scheme);
        //     root.currentColorScheme = scheme;
        // }

        function colorSchemeChange() {
            let scheme = Application.styleHints.colorScheme;
            console.log("Color scheme changed to", scheme);
            root.currentColorScheme = scheme;
        }
    }

    property bool darkMode: currentColorScheme !== Qt.ColorScheme.Light

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
    readonly property color border: darkMode ? Qt.hsla(0, 0, 0.95, 0.1) : Qt.hsla(0, 0, 0.05, 0.1)

    readonly property color accent: "#e06c75"

    readonly property color buttonEnabled: accent
    readonly property color buttonEnabledHover: Qt.lighter(accent, 0.9)
    readonly property color buttonDisabled: surface
    readonly property color buttonDisabledHover: Qt.rgba(surface.r, surface.g, surface.b, surface.a + 0.1)
}
