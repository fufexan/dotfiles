import org.kde.kirigami
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Bluetooth
import qs.components
import qs.utils

HoverTooltip {
    id: root

    property var adapter: Bluetooth.defaultAdapter
    property var state: adapter?.state
    property var connected: adapter?.devices.values.filter(d => d.state == BluetoothDeviceState.Connected)
    property var connecting: adapter?.devices.values.filter(d => d.state == BluetoothDeviceState.Connecting)

    visible: !!adapter

    readonly property string iconState: {
        if (adapter?.state === BluetoothAdapterState.Disabled)
            return "disabled";
        if (connecting?.length)
            return "acquiring";
        if (connected?.length)
            return "active";
        if (adapter?.state === BluetoothAdapterState.Enabled)
            return "disconnected";
        return "acquiring"; // fallback/unknown
    }
    readonly property string iconPath: Quickshell.iconPath(`bluetooth-${iconState}-symbolic`)

    text: {
        if (state == BluetoothAdapterState.Disabled)
            return "Bluetooth disabled";

        if (connecting?.length)
            return `Connecting to ${connecting[0].name}`;

        if (connected?.length) {
            if (connected.length > 1) {
                return `Connected to ${connected.length} devices`;
            }

            const d = connected[0];
            if (d.batteryAvailable) {
                return `${d.name} ${Math.round(d.battery * 100)}%`;
            }
            return d.name;
        }

        return "Bluetooth disconnected";
    }

    Icon {
        id: btIcon

        implicitHeight: Config.iconSize
        implicitWidth: Config.iconSize

        isMask: true
        color: Colors.foreground

        source: root.iconPath
    }

    MultiEffect {
        source: btIcon
        anchors.fill: btIcon
        shadowEnabled: Config.shadowEnabled
        shadowVerticalOffset: Config.shadowVerticalOffset
        blurMax: Config.blurMax
        opacity: Config.shadowOpacity
    }
}
