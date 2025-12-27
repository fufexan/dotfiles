pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import qs.utils
import qs.components

WrapperMouseArea {
    id: root
    Layout.fillWidth: true

    implicitHeight: wrapperItem.implicitHeight

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

    Item {
        id: wrapperItem

        implicitWidth: root.width
        implicitHeight: wrapper.implicitHeight

        RectangularShadow {
            anchors.fill: wrapper
            radius: wrapper.radius
            blur: Config.blurMax
            spread: Config.padding * 2
            color: Colors.windowShadow
        }

        WrapperRectangle {
            id: wrapper

            implicitWidth: parent.width
            color: Colors.bgBlurShadow
            margin: Config.spacing
            radius: Config.radius
            border {
                color: Colors.border
                width: 1
            }

            ColumnLayout {
                id: calendarColumn
                spacing: 5

                // Calendar header
                RowLayout {
                    id: row
                    Layout.fillWidth: true
                    Layout.leftMargin: Config.spacing
                    Layout.rightMargin: Config.spacing
                    // uniformCellSizes: true

                    HoverTooltip {
                        Layout.fillWidth: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.monthShift--
                        text: "Previous month"

                        Text {
                            // anchors.fill: parent
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
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
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            text: `${root.monthShift != 0 ? "• " : ""}${monthGrid.title}`
                        }
                    }
                    HoverTooltip {
                        // Layout.fillWidth: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.monthShift++
                        text: "Next month"
                        Text {
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            text: "›"
                        }
                    }
                }

                DayOfWeekRow {
                    locale: root.locale
                    Layout.fillWidth: true

                    delegate: Text {
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
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
                    property int cellH: 25
                    implicitHeight: rows * cellH

                    delegate: Item {
                        id: cellContainer
                        required property var model

                        readonly property bool today: model.day === root._today.getDate() && model.month === root._today.getMonth() && model.year === root._today.getFullYear()

                        WrapperRectangle {
                            implicitWidth: height

                            radius: Config.radius
                            anchors.centerIn: parent
                            margin: 5

                            color: cellContainer.today ? Colors.foreground : "transparent"

                            Text {
                                text: cellContainer.model.day

                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter

                                color: {
                                    if (cellContainer.model.month !== root.displayMonth) {
                                        return Colors.buttonDisabledHover;
                                    }
                                    if (cellContainer.today) {
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
    }
}
