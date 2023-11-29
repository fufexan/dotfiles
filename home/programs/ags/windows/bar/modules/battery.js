import { Battery, Widget } from "../../../imports.js";

export const BatteryModule = Widget.Icon({
  className: "battery module",

  binds: [
    ["icon", Battery, "icon-name"],
    [
      "tooltip-text",
      Battery,
      "percent",
      (res) => "Battery on " + res.toString() + "%",
    ],
  ],
});
