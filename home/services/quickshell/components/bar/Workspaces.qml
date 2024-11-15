import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.fillHeight: true
    color: "yellow"
    implicitWidth: workspacesText.width

    Text {
        id: workspacesText
        text: "Workspaces"
        anchors.centerIn: parent
    }
}
