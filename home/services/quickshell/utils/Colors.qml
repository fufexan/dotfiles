import QtQuick
import Quickshell
pragma Singleton

Singleton {
    property color bgBar: Qt.rgba(0, 0, 0, 0.21)
    property color bgBlur: Qt.rgba(0, 0, 0, 0.5)
    property color foreground: "white"
    property list<color> monitorColors: ["#e06c75", "#e5c07b", "#98c379", "#61afef"]
}
