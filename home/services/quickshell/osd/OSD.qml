pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import "../utils/."

Scope {
    id: scope
    property bool osdVisible: false
    property real progress: 0
    property string icon: ""

    Connections {
        target: PipeWireState.defaultSink?.audio

        function onChanged() {
            scope.osdVisible = true;
            scope.icon = PipeWireState.sinkIcon();
            scope.progress = PipeWireState.defaultSink?.audio.volume ?? 0;
            hideTimer.restart();
        }

        function onVolumeChanged() {
            onChanged();
        }

        function onMutedChanged() {
            onChanged();
        }
    }

    Connections {
        target: PipeWireState.defaultSource?.audio

        function onChanged() {
            scope.osdVisible = true;
            scope.icon = PipeWireState.sourceIcon();
            scope.progress = PipeWireState.defaultSource?.audio.volume ?? 0;
            hideTimer.restart();
        }

        function onVolumeChanged() {
            onChanged();
        }

        function onMutedChanged() {
            onChanged();
        }
    }

    Timer {
        id: hideTimer
        interval: Config.osdTimeout
        onTriggered: scope.osdVisible = false
    }

    LazyLoader {
        active: scope.osdVisible

        PanelWindow {
            id: root

            screen: Config.preferredMonitor

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "quickshell:osd"
            color: 'transparent'
            mask: Region {}

            anchors {
                bottom: true
            }

            implicitWidth: bg.implicitWidth
            implicitHeight: bg.implicitHeight + bg.anchors.bottomMargin

            Rectangle {
                id: bg
                radius: 16

                color: Colors.bgBar

                implicitHeight: Config.barHeight
                implicitWidth: 200

                anchors {
                    fill: parent
                    bottomMargin: Config.barHeight * 2
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
                        implicitWidth: parent.width * scope.progress ?? 0
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
                    source: Quickshell.iconPath(scope.icon)
                }
            }
        }
    }
}
