pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property color bgBar: Qt.rgba(0, 0, 0, 0.21)
    readonly property color bgBlur: Qt.rgba(0, 0, 0, 0.5)
    readonly property color bgBlurShadow: Qt.rgba(0, 0, 0, 0.4)
    readonly property color bg: Qt.rgba(0, 0, 0, 0.9)
    readonly property color foreground: Qt.hsla(0, 0, 0.95, 1)
    readonly property color foregroundBlur: Qt.rgba(255, 255, 255, 0.7)
    readonly property color windowShadow: Qt.rgba(0, 0, 0, 0.2)
    readonly property list<color> monitorColors: ["#e06c75", "#e5c07b", "#98c379", "#61afef"]

    readonly property color surface: Qt.rgba(255, 255, 255, 0.15)
    readonly property color overlay: Qt.rgba(255, 255, 255, 0.7)

    readonly property color accent: "#e06c75"

    readonly property color buttonEnabled: accent
    readonly property color buttonEnabledHover: Qt.lighter(accent, 0.9)
    readonly property color buttonDisabled: surface
    readonly property color buttonDisabledHover: Qt.rgba(surface.r, surface.g, surface.b, surface.a + 0.1)
}
