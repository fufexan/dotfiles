import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../utils"

Rectangle {
    id: resources

    Layout.fillHeight: true
    color: "transparent"
    implicitWidth: rowLayout.width

    property int valueSize: 8
    property int textSize: 6

    property string valueColor: "white"
    property string textColor: "lightgray"

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        ColumnLayout {
            id: cpuColumn
            Label {
                color: textColor
                font.pointSize: textSize
                text: "CPU"
                Layout.alignment: Qt.AlignCenter
            }
            Label {
                color: valueColor
                font.pointSize: valueSize
                text: Resources.cpu_percent + "%"
                Layout.alignment: Qt.AlignCenter
            }
        }

        ColumnLayout {
            Label {
                color: textColor
                font.pointSize: textSize
                text: "MEM"
                Layout.alignment: Qt.AlignCenter
            }
            Label {
                color: valueColor
                font.pointSize: valueSize
                text: Resources.mem_percent + "%"
                Layout.alignment: Qt.AlignCenter
            }
        }
    }
}
