import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils/"

WrapperMouseArea {
    id: root

    Layout.fillHeight: true

    acceptedButtons: Qt.RightButton | Qt.LeftButton

    onClicked: event => {
        event.accepted = true;

        Mpris.player.togglePlaying();
    }

    RowLayout {
        visible: Mpris.player
        Layout.fillHeight: true

        ClippingWrapperRectangle {
            radius: height / 2
            implicitWidth: 24
            implicitHeight: 24
            Image {
                id: artwork
                anchors.fill: parent
                source: Mpris.player?.trackArtUrl || ""
                fillMode: Image.PreserveAspectFit
                asynchronous: true
            }
        }

        Text {
            id: title
            color: "white"
            text: Mpris.player?.trackTitle || ""
            renderType: Text.NativeRendering
        }
    }
}
