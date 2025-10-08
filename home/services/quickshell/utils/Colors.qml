import QtQuick
import Quickshell
pragma Singleton

Singleton {
    property color bgBar: Qt.rgba(0, 0, 0, 0.21)
    property color bgBlur: Qt.rgba(0, 0, 0, 0.5)
    property color foreground: Qt.hsla(0, 0, 0.95, 1)
    property color foregroundBlur: Qt.rgba(255, 255, 255, 0.7)
    property list<color> monitorColors: ["#e06c75", "#e5c07b", "#98c379", "#61afef"]

    property color surface: Qt.rgba(255, 255, 255, 0.15)
    property color overlay: Qt.rgba(255, 255, 255, 0.7)

    property color accent: "#e06c75"

    property color buttonEnabled: accent
    property color buttonEnabledHover: Qt.lighter(accent, 0.9)
    property color buttonDisabled: surface
    property color buttonDisabledHover: Qt.rgba(surface.r, surface.g, surface.b, surface.a + 0.1)
}
