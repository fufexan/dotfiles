import qs.utils

Text {
    id: root
    property real fill: 0
    // property int grade: Colours.light ? 0 : -25
    property int grade: -25

    readonly property int targetSize: font.pointSize
    readonly property int targetWeight: font.weight

    font.family: "Material Symbols Rounded"
    font.pointSize: Config.iconSize + 1
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: root.targetSize,
            wght: root.targetWeight
        })
}
