import { Bluetooth, Widget } from "../../../imports.js";

export const BluetoothModule = Widget.Icon({
  className: "bluetooth module",

  binds: [
    [
      "icon",
      Bluetooth,
      "connected-devices",
      (connected) => {
        if (!Bluetooth.enabled) return "bluetooth-disabled";
        if (connected.length > 0) return "bluetooth-paired";
        return "bluetooth-active";
      },
    ],
    [
      "tooltip-text",
      Bluetooth,
      "connected-devices",
      (connected) => {
        if (!Bluetooth.enabled) return "Bluetooth off";

        if (connected.length > 0) {
          let dev = Bluetooth.getDevice(connected.at(0).address);
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
