import qs.utils

Text {
    property real fill: 0
    // property int grade: Colours.light ? 0 : -25
    property int grade: -25

    font.family: "Material Symbols Rounded"
    font.pointSize: Config.iconSize + 1
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: font.pixelSize,
            wght: font.weight
        })
}
