import org.kde.kirigami
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Networking
import qs.components
import qs.utils

HoverTooltip {
    id: root

    property NetworkDevice adapter: Networking.devices?.values[0] ?? null

    readonly property WifiNetwork activeNetwork: adapter?.networks?.values.find(network => network.connected) ?? null

    visible: !!Networking.devices?.values

    readonly property string iconState: {
        if (!Networking.wifiHardwareEnabled)
            return "hardware-disabled";
        else if (!Networking.wifiEnabled)
            return "disabled";
        else if (adapter?.state == DeviceConnectionState.Connecting || adapter?.state == DeviceConnectionState.Disconnecting)
            return "acquiring";
        else if (adapter?.connected) {
            let strength = "good";

            if (activeNetwork?.signalStrength >= 0.66) {
                strength = "good";
            } else if (activeNetwork?.signalStrength >= 0.33) {
                strength = "ok";
            } else {
                strength = "weak";
            }
            return `signal-${strength}`;
        }
        return "offline";
    }
    readonly property string iconPath: Quickshell.iconPath(`network-wireless-${iconState}-symbolic`)

    text: {
        if (!Networking.wifiEnabled)
            return "WiFi disabled";
        else if (adapter?.state == DeviceConnectionState.Connecting)
            return `Connecting to ${activeNetwork.name}`;
        else if (adapter?.state == DeviceConnectionState.Disconnecting)
            return `Disconnecting from ${activeNetwork.name}`;
        else if (adapter?.connected)
            return activeNetwork?.name ?? null;

        return "Disconnected";
    }

    Icon {
        id: wifiIcon

        implicitHeight: Config.iconSize
        implicitWidth: Config.iconSize

        isMask: true
        color: Colors.foreground

        source: root.iconPath
    }

    MultiEffect {
        source: wifiIcon
        anchors.fill: wifiIcon
        shadowEnabled: Config.shadowEnabled
        shadowVerticalOffset: Config.shadowVerticalOffset
        blurMax: Config.blurMax
        opacity: Config.shadowOpacity
    }
}
