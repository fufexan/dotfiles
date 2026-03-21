import QtQuick
import QtQuick.Controls
import qs.components
import qs.utils

Loader {
    id: root

    required property string text
    property bool show: false

    active: text !== ""
    visible: show && active

    anchors.fill: parent

    ToolTip {
        id: tooltip

        visible: parent.visible
        popupType: Popup.Window

        text: parent.text
        delay: 500

        x: parent.x + parent.width / 2 - width / 2
        y: parent.y + parent.height + Config.padding

        contentItem: Text {
            text: tooltip.text
            font: tooltip.font
        }

        background: Squircle {
            color: Colors.bgBlur
            strokeWidth: 1
            strokeColor: Colors.border
        }
    }
}
