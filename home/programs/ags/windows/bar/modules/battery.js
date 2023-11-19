import { Widget, Battery } from "../../../imports.js";

export const BatteryModule = Widget.Icon({
  className: "battery",

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
