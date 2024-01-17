import { App, Bluetooth, Network, Utils, Widget } from "../../imports.js";

import { getNetIcon, getNetText } from "../../utils/net.js";
import { getBluetoothIcon, getBluetoothText } from "../../utils/bluetooth.js";

const Toggle = (args) =>
  Widget.Box({
    ...args.props ?? {},
    className: `toggle ${args.name}`,
    hexpand: true,
    hpack: "start",

    children: [
      Widget.Button({
        className: "button",

        child: Widget.Icon({
          setup: args.icon.setup,
        }),
        setup: args.icon.buttonSetup,
      }),
      Widget.Button({
        hexpand: true,
        child: Widget.Label({
          hpack: "start",
          setup: args.label.setup,
        }),
        setup: args.label.buttonSetup,
      }),
    ],
  });

const net = {
  name: "net",
  icon: {
    setup: (self) =>
      self
        .bind("icon", Network, "connectivity", getNetIcon)
        .bind("icon", Network.wifi, "icon-name", getNetIcon),

    buttonSetup: (self) => {
      self.onPrimaryClick = () => Network.toggleWifi();
      self.hook(
        Network,
        (btn) =>
          btn.toggleClassName("disabled", Network.connectivity != "full"),
        "notify::connectivity",
      );
    },
  },
  label: {
    setup: (self) =>
      self
        .bind("label", Network, "connectivity", () => getNetText())
        .bind("label", Network.wifi, "ssid", () => getNetText()),

    buttonSetup: (self) => {
      self.onPrimaryClick = () => {
        App.toggleWindow("system-menu");
        Utils.execAsync([
          "sh",
          "-c",
          "XDG_CURRENT_DESKTOP=GNOME gnome-control-center",
        ]);
      };
    },
  },
};

const bt = {
  name: "bluetooth",
  icon: {
    setup: (self) =>
      self.bind(
        "icon",
        Bluetooth,
        "connected-devices",
        getBluetoothIcon,
      ),
    buttonSetup: (self) => {
      self.onPrimaryClick = () => Bluetooth.toggle();
      self.hook(
        Bluetooth,
        (btn) => btn.toggleClassName("disabled", !Bluetooth.enabled),
        "notify::enabled",
      );
    },
  },
  label: {
    setup: (self) =>
      self.bind(
        "label",
        Bluetooth,
        "connected-devices",
        getBluetoothText,
      ),
    buttonSetup: (self) => {
      self.onPrimaryClick = () => {
        App.toggleWindow("system-menu");
        Utils.execAsync("overskride");
      };
    },
  },
};

export default () =>
  Widget.Box({
    className: "toggles",
    vertical: true,

    children: [
      Toggle(net),
      Toggle(bt),
    ],
  });
