import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../utils/."
import "../components"

WrapperMouseArea {
    id: root

    Layout.fillHeight: true

    acceptedButtons: Qt.RightButton | Qt.LeftButton

    onClicked: event => {
        event.accepted = true;

        MprisState.player.togglePlaying();
    }

    RowLayout {
        visible: MprisState.player
        Layout.fillHeight: true

        ClippingWrapperRectangle {
            radius: height / 2
            margin: 12

            IconImage {
                id: artwork
                anchors.fill: parent
                source: MprisState.player?.trackArtUrl || ""
                asynchronous: true
            }
        }

        Text {
            id: title
            text: MprisState.player?.trackTitle || ""
        }
    }
}
