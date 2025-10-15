pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import "../utils/."
import "../components"

WrapperMouseArea {
    id: root
    Layout.fillWidth: true

    implicitWidth: wrapper.implicitWidth
    implicitHeight: wrapper.implicitHeight

    readonly property int gridW: Math.floor(width / 7) * 7
    property var locale: Qt.locale("en_GB")
    property int monthShift: 0

    readonly property date _today: new Date()
    readonly property int displayYear: _today.getFullYear() + Math.floor((_today.getMonth() + monthShift) / 12)
    readonly property int displayMonth: (_today.getMonth() + monthShift + 12) % 12

    acceptedButtons: Qt.NoButton
    onWheel: event => {
        root.monthShift += (event.angleDelta.y < 0) ? 1 : -1;
    }

    WrapperRectangle {
        id: wrapper
        color: Colors.bgBlur
        margin: 12
        radius: 16

        ColumnLayout {
            id: calendarColumn
            spacing: 5

            // Calendar header
            RowLayout {
                id: row
                Layout.fillWidth: true
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                // uniformCellSizes: true

                HoverTooltip {
                    Layout.fillWidth: true
                    acceptedButtons: Qt.LeftButton
                    onClicked: root.monthShift--
                    text: "Previous month"

                    Text {
                        // anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "‹"
                    }
                }
                HoverTooltip {
                    Layout.fillWidth: true
                    // Layout.alignment: Qt.AlignCenter
                    acceptedButtons: Qt.LeftButton
                    onClicked: root.monthShift = 0
                    text: (root.monthShift === 0) ? "" : "Jump to current month"
                    Text {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: `${root.monthShift != 0 ? "• " : ""}${monthGrid.title}`
                    }
                }
                HoverTooltip {
                    // Layout.fillWidth: true
                    acceptedButtons: Qt.LeftButton
                    onClicked: root.monthShift++
                    text: "Next month"
                    Text {
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "›"
                    }
                }
            }

            DayOfWeekRow {
                locale: root.locale
                Layout.fillWidth: true

                delegate: Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: shortName
                    font.weight: Font.Bold

                    required property string shortName
                }
            }

            MonthGrid {
                id: monthGrid
                locale: root.locale
                Layout.fillWidth: true

                month: root.displayMonth
                year: root.displayYear

                width: parent.width
                property int rows: 6
                property int cellH: 24
                implicitHeight: rows * cellH

                delegate: WrapperRectangle {
                    id: wr
                    required property var model
                    radius: 16
                    readonly property bool today: model.day === root._today.getDate() && model.month === root._today.getMonth() && model.year === root._today.getFullYear()
                    color: today ? Colors.foreground : "transparent"

                    Text {
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: wr.model.day
                        // font: control.font
                        color: {
                            if (wr.model.month !== root.displayMonth) {
                                return Colors.buttonDisabledHover;
                            }
                            if (wr.today) {
                                return Colors.bg;
                            }
                            return Colors.foreground;
                        }
                    }
                }
            }
        }
    }
}
