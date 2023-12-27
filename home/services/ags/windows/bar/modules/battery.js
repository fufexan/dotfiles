import { Battery, Widget } from "../../../imports.js";

export default () =>
  Widget.Icon({ className: "battery module" })
    .bind("icon", Battery, "icon-name")
    .bind("tooltip-text", Battery, "percent", (p) => `Battery on ${p}%`);
