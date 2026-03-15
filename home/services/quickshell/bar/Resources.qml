pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.utils
import qs.components

Item {
    id: root

    Layout.fillHeight: true
    implicitWidth: virtualRowLayout.width

    readonly property int valueSize: 7
    readonly property int textSize: 5
    readonly property int spacing: 0

    property color valueColor: Colors.foreground
    property color textColor: Colors.overlay

    // Prevents this component making the bar's elements shift around
    RowLayout {
        id: virtualRowLayout
        opacity: 0
        anchors.centerIn: parent

        Repeater {
            model: 2
            Text {
                font.pointSize: root.textSize
                text: "100%"
            }
        }
    }

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        HoverTooltip {
            text: ResourcesState.cpu_freq

            ColumnLayout {
                spacing: root.spacing

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
        }

        HoverTooltip {
            text: ResourcesState.mem_used

            ColumnLayout {
                spacing: root.spacing

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
}
