import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami

Rectangle {
    id: bat

    Layout.preferredWidth: batIcon.width
    Layout.fillHeight: true
    color: 'transparent'

    readonly property var battery: UPower.displayDevice
    readonly property int percentage: Math.round(battery.percentage * 100)
    property var size: height * 0.4

    visible: battery.isLaptopBattery

    Icon {
        id: batIcon
        anchors.centerIn: parent

        implicitHeight: bat.size
        implicitWidth: bat.size

        // This recolors the entire svg, instead of only classless components.
        // Hopefully in the future classes can be selected for recoloring.
        isMask: true
        color: 'white'

        source: {
            const nearestTen = Math.round(bat.percentage / 10) * 10;
            const number = nearestTen.toString().padStart(2, "0");
            let charging;

            if (bat.battery.state == UPowerDeviceState.Charging) {
                charging = "-charging";
            } else if (bat.battery.state.toString() == UPowerDeviceState.FullyCharged) {
                charging = "-charged";
            } else {
                charging = "";
            }

            return Quickshell.iconPath(`battery-level-${number}${charging}-symbolic`);
        }
    }
}
