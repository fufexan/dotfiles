import org.kde.kirigami
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Icon {
    id: batIcon

    readonly property var battery: UPower.displayDevice
    readonly property int percentage: Math.round(battery.percentage * 100)

    visible: battery.isLaptopBattery
    // anchors.centerIn: parent

    implicitHeight: 16
    implicitWidth: 16

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
