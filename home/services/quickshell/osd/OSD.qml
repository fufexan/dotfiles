pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import qs.utils

Scope {
    id: scope
    property bool osdVisible: false
    property real progress: 0
    property string icon: ""

    Connections {
        target: PipeWireState.defaultSink ? PipeWireState.defaultSink.audio : null

        function update() {
            scope.osdVisible = true;
            scope.icon = PipeWireState.sinkIcon();
            scope.progress = PipeWireState.defaultSink?.audio.volume ?? 0;
            hideTimer.restart();
        }

        function onVolumeChanged() {
            update();
        }

        function onMutedChanged() {
            update();
        }
    }

    Connections {
        target: PipeWireState.defaultSource ? PipeWireState.defaultSource.audio : null

        function update() {
            scope.osdVisible = true;
            scope.icon = PipeWireState.sourceIcon();
            scope.progress = PipeWireState.defaultSource?.audio.volume ?? 0;
            hideTimer.restart();
        }

        function onVolumeChanged() {
            update();
        }

        function onMutedChanged() {
            update();
        }
    }

    Connections {
        target: BrightnessState

        function onBrightnessChanged() {
            scope.osdVisible = true;
            scope.icon = "display-brightness-symbolic";
            scope.progress = BrightnessState.brightness ?? 0;
            hideTimer.restart();
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

            margins {
                bottom: Config.barHeight
            }

            implicitWidth: bg.width + (Config.padding * 8)
            implicitHeight: bg.height + (Config.padding * 10)

            SquircleShader {
                id: bg
                radius: Config.radius
                color: Colors.bgBar

                anchors.centerIn: parent

                implicitHeight: Config.barHeight * 1.2
                implicitWidth: Config.osdWidth + Config.padding * 8

                progressColor: Colors.foregroundOSD
                progress: scope.progress

                Behavior on progress {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }
            }

            IconImage {
                id: icon

                anchors {
                    horizontalCenter: bg.left
                    horizontalCenterOffset: icon.implicitSize + Config.padding
                    verticalCenter: bg.verticalCenter
                }
                mipmap: true
                implicitSize: Config.iconSize
                source: Quickshell.iconPath(scope.icon)
            }

            RectangularShadow {
                anchors.fill: bg
                radius: bg.radius
                offset.y: Config.padding
                blur: Config.blurMax
                spread: Config.padding * 2
                color: Colors.windowShadow
            }
        }
    }
}
