import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.fillHeight: true
    color: "pink"
    implicitWidth: systemText.width

    Text {
        id: systemText
        anchors.centerIn: parent
        text: "System"
    }
}
