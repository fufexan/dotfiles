import org.kde.kirigami
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import "../components"

WrapperMouseArea {
    id: root

    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    onEntered: timer.running = true
    onExited: {
        timer.running = false;
        tooltip.visible = false;
    }

    Timer {
        id: timer
        interval: 500
        repeat: false
        onTriggered: tooltip.visible = true
    }

    TextTooltip {
        id: tooltip
        targetItem: root
        targetRect: Qt.rect(root.width / 2, root.height + 8, 0, 0)
        targetText: `Battery on ${batIcon.percentage}%`
    }

    Icon {
        id: batIcon

        readonly property var battery: UPower.displayDevice
        readonly property int percentage: Math.round(battery.percentage * 100)

        visible: battery.isLaptopBattery

        implicitHeight: 14
        implicitWidth: 14

        // This recolors the entire svg, instead of only classless components.
        // Hopefully in the future classes can be selected for recoloring.
        isMask: true
        color: 'white'

        source: {
            const nearestTen = Math.round(percentage / 10) * 10;
            const number = nearestTen.toString().padStart(2, "0");
            let charging;

            if (battery.state == UPowerDeviceState.Charging) {
                // My battery is old and keeps staying at 94-96% while plugged in
                if (nearestTen == 100) {
                    charging = "-charged";
                } else {
                    charging = "-charging";
                }
            } else if (battery.state.toString() == UPowerDeviceState.FullyCharged) {
                charging = "-charged";
            } else {
                charging = "";
            }

            return Quickshell.iconPath(`battery-level-${number}${charging}-symbolic`);
        }
    }
}
