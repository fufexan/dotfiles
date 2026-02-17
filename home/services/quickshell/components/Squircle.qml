import QtQuick
import qs.utils

Item {
    id: root

    // Geometry
    property real radius: Config.radius
    property real power: Config.roundingPower

    // Styling
    property color color: "black"
    property color strokeColor: "transparent"
    property real strokeWidth: 0

    // Progress (Optional)
    property color progressColor: color
    property real progress: 0.0

    // Set content to be clipped
    property alias content: contentContainer.children

    ShaderEffectSource {
        id: effectSource
        sourceItem: contentContainer
        anchors.fill: parent
        visible: false
    }

    ShaderEffect {
        id: shader
        anchors.fill: parent

        property vector2d resolution: Qt.vector2d(width, height)
        property vector4d fillColor: Qt.vector4d(root.color.r, root.color.g, root.color.b, root.color.a)
        property vector4d progressColor: Qt.vector4d(root.progressColor.r, root.progressColor.g, root.progressColor.b, root.progressColor.a)
        property vector4d strokeColor: Qt.vector4d(root.strokeColor.r, root.strokeColor.g, root.strokeColor.b, root.strokeColor.a)
        property real strokeWidth: root.strokeWidth
        property real radius: root.radius
        property real power: root.power
        property real progress: root.progress

        property real useTexture: contentContainer.children.length > 0 ? 1.0 : 0.0
        property variant sourceTexture: effectSource

        fragmentShader: Qt.resolvedUrl("squircle.frag.qsb")

        layer.enabled: true
        layer.smooth: true
    }

    Item {
        id: contentContainer
        anchors.fill: parent
        visible: false
    }
}
