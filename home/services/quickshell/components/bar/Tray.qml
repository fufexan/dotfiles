import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.fillHeight: true
    color: "lightblue"
    implicitWidth: trayText.width

    Text {
        id: trayText
        text: "Tray"
        anchors.centerIn: parent
    }
}
