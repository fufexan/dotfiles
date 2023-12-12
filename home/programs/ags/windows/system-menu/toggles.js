import {
  Bluetooth,
  Gtk,
  Icons,
  Network,
  systemMenuVisible,
  Utils,
  Widget,
} from "../../imports.js";

const Toggle = (args) =>
  Widget.Box({
    ...args.props ?? {},
    className: `toggle ${args.name}`,
    hexpand: true,
    halign: Gtk.Align.START,

    children: [
      Widget.Button({
        className: "button",
        onPrimaryClick: args.icon.action,

        child: Widget.Icon({
          binds: args.icon.binds,
        }),
        connections: args.icon.buttonConnections ?? [],
      }),
      Widget.Button({
        onPrimaryClick: args.label.action,

        child: Widget.Label({
          binds: args.label.binds,
        }),
        connections: args.label.buttonConnections ?? [],
      }),
    ],
  });

const net = {
  name: "net",
  icon: {
    action: () => Network.toggleWifi(),
    binds: [
      [
        "icon",
        Network,
        "connectivity",
        (conn) => {
          if (conn == "none") return "";
          if (Network.primary == "wired") return "network-wired";

          return Network.wifi.icon_name;
        },
      ],
      [
        "icon",
        Network.wifi,
        "icon-name",
      ],
    ],
    buttonConnections: [[
      Network,
      (btn) => btn.toggleClassName("disabled", Network.connectivity != "full"),
      "notify::connectivity",
    ]],
  },
  label: {
    action: () => {
      systemMenuVisible.value = !systemMenuVisible.value;
      Utils.exec("sh -c 'XDG_CURRENT_DESKTOP=GNOME gnome-control-center'");
    },
    binds: [
      [
        "label",
        Network,
        "connectivity",
        (conn) => {
          if (conn == "none") return "";
          if (Network.primary == "wired") return "Wired";

          return Network.wifi.ssid;
        },
      ],
      [
        "label",
        Network.wifi,
        "ssid",
      ],
    ],
  },
};

const bt = {
  name: "bluetooth",
  icon: {
    action: () => Bluetooth.toggle(),
    binds: [[
      "icon",
      Bluetooth,
      "connected-devices",
      () => {
        if (!Bluetooth.enabled) return Icons.bluetooth.disabled;
        if (Bluetooth.connectedDevices.length > 0) {
          return Icons.bluetooth.active;
        }
        return Icons.bluetooth.disconnected;
      },
    ]],
    buttonConnections: [[
      Bluetooth,
      (btn) => btn.toggleClassName("disabled", !Bluetooth.enabled),
      "notify::enabled",
    ]],
  },
  label: {
    action: () => {
      systemMenuVisible.value = !systemMenuVisible.value;
      Utils.execAsync("blueberry");
    },
    binds: [[
      "label",
      Bluetooth,
      "connected-devices",
      (conn) => {
        if (!Bluetooth.enabled) return "Bluetooth off";

        if (conn.length > 0) {
          const dev = Bluetooth.getDevice(
            conn.at(0).address,
          );
          let battery_str = "";

          if (dev.battery_percentage > 0) {
            battery_str += " " + dev.battery_percentage + "%";
          }

          return dev.name + battery_str;
        }

        return "Bluetooth on";
      },
    ]],
  },
};

export default Widget.Box({
  className: "toggles",
  vertical: true,

  children: [
    Toggle(net),
    Toggle(bt),
  ],
});
