import { Battery, Widget } from "../../../imports.js";

export default Widget.Icon({
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
