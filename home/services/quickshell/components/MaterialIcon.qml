import QtQuick
import "../utils/."

Text {
    property real fill: 0
    // property int grade: Colours.light ? 0 : -25
    property int grade: -25
    color: Colors.foreground

    font.family: "Material Symbols Rounded"
    font.pointSize: Config.iconSize + 1
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
