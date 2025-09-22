import QtQuick
import QtQuick.Layouts
import "../utils/."
import "../components"

Rectangle {
    id: root

    Layout.fillHeight: true
    color: "transparent"
    implicitWidth: rowLayout.width

    property int valueSize: 7
    property int textSize: 5

    property color valueColor: Colors.foreground
    property string textColor: "lightgray"

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        ColumnLayout {
            id: cpuColumn
            Text {
                color: root.textColor
                font.pointSize: root.textSize
                text: "CPU"
                Layout.alignment: Qt.AlignCenter
            }
            Text {
                color: root.valueColor
                font.pointSize: root.valueSize
                text: ResourcesState.cpu_percent + "%"
                Layout.alignment: Qt.AlignCenter
            }
        }

        ColumnLayout {
            Text {
                color: root.textColor
                font.pointSize: root.textSize
                text: "MEM"
                Layout.alignment: Qt.AlignCenter
            }
            Text {
                color: root.valueColor
                font.pointSize: root.valueSize
                text: ResourcesState.mem_percent + "%"
                Layout.alignment: Qt.AlignCenter
            }
        }
    }
}
