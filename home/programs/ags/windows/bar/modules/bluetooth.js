import { Bluetooth, Widget } from "../../../imports.js";

export const BluetoothModule = Widget.Icon({
  className: "bluetooth module",

  binds: [
    [
      "icon",
      Bluetooth,
      "connected-devices",
      (connected) => {
        if (!Bluetooth.enabled) return "bluetooth-disabled-symbolic";
        if (connected.length > 0) return "bluetooth-active-symbolic";
        return "bluetooth-disconnected-symbolic";
      },
    ],
    [
      "tooltip-text",
      Bluetooth,
      "connected-devices",
      (connected) => {
        if (!Bluetooth.enabled) return "Bluetooth off";

        if (connected.length > 0) {
          const dev = Bluetooth.getDevice(connected.at(0).address);
          let battery_str = "";

          if (dev.battery_percentage > 0) {
            battery_str += " " + dev.battery_percentage + "%";
          }

          return dev.name + battery_str;
        }

        return "Bluetooth on";
      },
    ],
  ],
});
