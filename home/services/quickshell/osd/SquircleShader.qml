import QtQuick

ShaderEffect {
    id: effect

    property color color: "black"
    property real radius: 20
    property real exponent: 2.5
    property real progress: 1.0
    property color progressColor: "white"

    property real ratio: width / height

    readonly property vector4d selectionColor: Qt.vector4d(color.r, color.g, color.b, color.a)
    readonly property vector4d fillWeightColor: Qt.vector4d(progressColor.r, progressColor.g, progressColor.b, progressColor.a)

    fragmentShader: "squircle.frag.qsb"
}
