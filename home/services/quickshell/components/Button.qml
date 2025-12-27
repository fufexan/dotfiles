import QtQuick
import qs.utils
import qs.components

HoverTooltip {
    id: root

    required property string buttonText

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton

    Rectangle {
        radius: Config.radius
        color: root.containsMouse ? Colors.buttonDisabledHover : Colors.buttonDisabled
        implicitHeight: text.height + 2 * Config.padding
        implicitWidth: parent.width || text.width + 2 * Config.padding
        border {
            color: Colors.border
            width: 1
        }

        Text {
            id: text

            anchors.centerIn: parent
            text: root.buttonText
            elide: Text.ElideRight
            maximumLineCount: 1
            wrapMode: Text.Wrap
        }
    }
}
