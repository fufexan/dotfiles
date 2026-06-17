import org.kde.kirigami
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Networking
import qs.components
import qs.utils

HoverTooltip {
    id: root

    property list<NetworkDevice> connectedAdapters: Networking.devices.values.filter(e => e.connected)

    property list<NetworkDevice> wiredAdapters: connectedAdapters.filter(e => e.type === DeviceType.Wired)

    property NetworkDevice adapter: {
        if (wiredAdapters.length > 0)
            return wiredAdapters[0] ?? null;
        else
            return connectedAdapters[0] ?? null;
    }

    readonly property Network activeNetwork: {
        if (adapter?.type === DeviceType.Wired)
            return (adapter as WiredDevice).network ?? null;
        return adapter?.networks?.values.find(network => network.connected) ?? null;
    }

    visible: Networking.devices.values.length > 0

    readonly property string iconState: {
        if (!Networking.wifiHardwareEnabled)
            return "hardware-disabled";
        else if (!Networking.wifiEnabled)
            return "disabled";
        else if (adapter?.state == ConnectionState.Connecting || adapter?.state == ConnectionState.Disconnecting)
            return "acquiring";
        else if (adapter?.connected) {
            const strength = activeNetwork?.signalStrength >= 0.66 ? "good" : activeNetwork?.signalStrength >= 0.33 ? "ok" : "weak";
            return `signal-${strength}`;
        }
        return "offline";
    }
    readonly property string iconPath: {
        let icon;
        if (adapter?.type === DeviceType.Wired)
            icon = "wired";
        else
            icon = `wireless-${iconState}`;
        return Quickshell.iconPath(`network-${icon}-symbolic`);
    }

    text: {
        if (adapter?.type === DeviceType.Wired)
            return `${activeNetwork.name}\n${(adapter as WiredDevice).linkSpeed} Mbps`;
        if (!Networking.wifiEnabled)
            return "WiFi disabled";
        else if (adapter?.state == ConnectionState.Connecting)
            return `Connecting to ${activeNetwork.name}`;
        else if (adapter?.state == ConnectionState.Disconnecting)
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
