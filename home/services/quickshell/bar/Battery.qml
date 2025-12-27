import org.kde.kirigami
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.UPower
import qs.components
import qs.utils

HoverTooltip {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property int percentage: Math.round(battery.percentage * 100)
    visible: battery.isLaptopBattery

    text: `Battery on ${percentage}%`

    Icon {
        id: batIcon

        implicitHeight: Config.iconSize
        implicitWidth: Config.iconSize

        // This recolors the entire svg, instead of only classless components.
        // Hopefully in the future classes can be selected for recoloring.
        isMask: true
        color: Colors.foreground

        source: {
            const nearestTen = Math.round(root.percentage / 10) * 10;
            const number = nearestTen.toString().padStart(2, "0");
            let charging;

            if (root.battery.state == UPowerDeviceState.Charging) {
                // My battery is old and keeps staying at 94-96% while plugged in
                if (nearestTen == 100) {
                    charging = "-charged";
                } else {
                    charging = "-charging";
                }
            } else if (root.battery.state == UPowerDeviceState.FullyCharged) {
                charging = "-charged";
            } else {
                charging = "";
            }

            return Quickshell.iconPath(`battery-level-${number}${charging}-symbolic`);
        }
    }

    MultiEffect {
        source: batIcon
        anchors.fill: batIcon
        shadowEnabled: Config.shadowEnabled
        shadowVerticalOffset: Config.shadowVerticalOffset
        blurMax: Config.blurMax
        opacity: Config.shadowOpacity
    }
}
