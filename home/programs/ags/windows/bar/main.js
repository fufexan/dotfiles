import { Date } from "./modules/date.js";
import { Widget } from "../../imports.js";

const Start = Widget.Box({
  children: [
    // Workspaces,
    // Indicators
  ],
});

const Center = Widget.Box({
  children: [
    // Music
  ],
});

const End = Widget.Box({
  children: [
    Widget.Box({ hexpand: true }),
    // Tray,
    // SystemInfo,
    // Net,
    // Bluetooth,
    // Battery,
    Date,
  ],
});

export default Widget.Window({
  monitor: 0,
  name: `bar`,
  anchor: ["top", "left", "right"],

  child: Widget.CenterBox({
    className: "bar",

    startWidget: Start,
    centerWidget: Center,
    endWidget: End,
  }),
});
