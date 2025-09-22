import QtQuick
import QtQuick.Layouts
import "../utils/."
import "../components"

Rectangle {
    id: resources

    Layout.fillHeight: true
    color: "transparent"
    implicitWidth: rowLayout.width

    property int valueSize: 8
    property int textSize: 6

    property color valueColor: Colors.foreground
    property string textColor: "lightgray"

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        ColumnLayout {
            id: cpuColumn
            Text {
                color: textColor
                font.pointSize: textSize
                text: "CPU"
                Layout.alignment: Qt.AlignCenter
            }
            Text {
                color: valueColor
                font.pointSize: valueSize
                text: ResourcesState.cpu_percent + "%"
                Layout.alignment: Qt.AlignCenter
            }
        }

        ColumnLayout {
            Text {
                color: textColor
                font.pointSize: textSize
                text: "MEM"
                Layout.alignment: Qt.AlignCenter
            }
            Text {
                color: valueColor
                font.pointSize: valueSize
                text: ResourcesState.mem_percent + "%"
                Layout.alignment: Qt.AlignCenter
            }
        }
    }
}
