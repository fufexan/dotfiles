import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import "../utils/."

PanelWindow {
    id: root

    visible: false
    screen: Config.preferredMonitor

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:osd"
    color: 'transparent'
    mask: Region {}

    anchors {
        bottom: true
    }

    implicitWidth: 200
    implicitHeight: bg.implicitHeight + bg.anchors.bottomMargin

	Connections {
		target: PipeWireState.defaultSink?.audio

		function onVolumeChanged() {
			root.visible = true;
			hideTimer.restart();
		}
	}

	Timer {
	    id: hideTimer
	    interval: Config.osdTimeout
	    onTriggered: root.visible = false
	}

    Rectangle {
        id: bg
        radius: 16

        color: Colors.bgBar

        implicitHeight: 32

        anchors {
            fill: parent
            bottomMargin: 64
        }

        ClippingWrapperRectangle {
            id: progress
            anchors.fill: parent
            radius: 16
            resizeChild: false
            color: 'transparent'

            Rectangle {
                color: Colors.foregroundBlur
                anchors.left: parent.left
                implicitHeight: 32
                implicitWidth: parent.width * PipeWireState.defaultSink?.audio?.volume ?? 0
            }
        }

        IconImage {
            id: icon

            anchors {
                horizontalCenter: bg.left
                horizontalCenterOffset: icon.implicitSize + 4
                verticalCenter: bg.verticalCenter
            }
            mipmap: true
            implicitSize: Config.iconSize
            source: Quickshell.iconPath("audio-volume-high-symbolic")
        }
    }
}
