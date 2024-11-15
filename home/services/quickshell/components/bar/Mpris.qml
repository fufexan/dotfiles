import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.fillHeight: true
    color: "salmon"
    implicitWidth: mprisText.width

    Text {
        id: mprisText
        text: "Mpris"
        anchors.centerIn: parent
    }
}
