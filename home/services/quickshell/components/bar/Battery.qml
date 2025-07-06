import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami

WrapperRectangle {
    id: bat

    Layout.fillHeight: true
    color: 'transparent'

    readonly property var battery: UPower.displayDevice
    readonly property int percentage: Math.round(battery.percentage * 100)

    visible: battery.isLaptopBattery

    Icon {
        id: batIcon
        anchors.centerIn: parent

        implicitHeight: 16
        implicitWidth: 16

        // This recolors the entire svg, instead of only classless components.
        // Hopefully in the future classes can be selected for recoloring.
        isMask: true
        color: 'white'

        source: {
            const nearestTen = Math.round(bat.percentage / 10) * 10;
            const number = nearestTen.toString().padStart(2, "0");
            let charging;

            if (bat.battery.state == UPowerDeviceState.Charging) {
                // My battery is old and keeps staying at 94-96% while plugged in
                if (nearestTen == 100) {
                    charging = "-charged";
                } else {
                    charging = "-charging";
                }
            } else if (bat.battery.state.toString() == UPowerDeviceState.FullyCharged) {
                charging = "-charged";
            } else {
                charging = "";
            }

            return Quickshell.iconPath(`battery-level-${number}${charging}-symbolic`);
        }
    }
}
