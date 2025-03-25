import Quickshell
pragma Singleton

Singleton {
    property var bgBar: Qt.rgba(0, 0, 0, 0.21)
    property var bgBlur: Qt.rgba(0, 0, 0, 0.3)
    property var fg: "white"
    property list<var> monitorColors: ["#e06c75", "#e5c07b", "#98c379", "#61afef"]
}
