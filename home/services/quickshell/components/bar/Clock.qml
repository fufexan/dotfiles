import QtQuick
import QtQuick.Layouts
import "../../utils"

Rectangle {
    Layout.fillHeight: true
    color: "transparent"
    implicitWidth: clockText.width

    Text {
        id: clockText
        text: Time.time
        color: Colors.fg
        anchors.centerIn: parent
    }
}
