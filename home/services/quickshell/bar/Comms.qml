import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.utils
import org.kde.kirigami

WrapperItem {
    id: root

    RowLayout {
        id: rowLayout

        Repeater {
            model: root.comms

            CommItem {}
        }
    }

    property var comms: [
        {
            name: "Camera",
            visible: CommsState.cameraActive,
            icon: "camera-photo-symbolic",
            color: Colors.monitorColors[3]
        },
        {
            name: "Microphone",
            visible: CommsState.microphoneActive,
            icon: CommsState.microphoneMuted ? "microphone-disabled-symbolic" : "audio-input-microphone-symbolic",
            color: Colors.monitorColors[2]
        },
        {
            name: "Screenshare",
            visible: CommsState.screensharingActive,
            icon: "screen-shared-symbolic",
            color: Colors.monitorColors[0]
        },
    ]

    component CommItem: HoverTooltip {
        id: itemRoot

        visible: modelData.visible
        required property var modelData
        text: modelData.name + " active"

        WrapperRectangle {
            radius: Config.radius
            margin: 3
            color: itemRoot.modelData.color

            Icon {
                source: itemRoot.modelData.icon

                implicitHeight: Config.iconSize - parent.margin
                implicitWidth: Config.iconSize - parent.margin

                isMask: true
                color: Colors.bg
            }
        }
    }
}
