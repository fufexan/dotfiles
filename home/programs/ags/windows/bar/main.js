import { BatteryModule } from "./modules/battery.js";
import { Date } from "./modules/date.js";
import { Widget } from "../../imports.js";
import { Net } from "./modules/net.js";
import { BluetoothModule } from "./modules/bluetooth.js";
import { SystemInfo } from "./modules/system_info.js";
import { Workspaces } from "./modules/workspaces.js";
import { Music } from "./modules/music.js";

const Start = Widget.Box({
  children: [
    Workspaces,
    // Indicators
  ],
});

const Center = Widget.Box({
  children: [Music],
});

const End = Widget.Box({
  children: [
    Widget.Box({ hexpand: true }),
    // Tray,
    SystemInfo,
    Net,
    BluetoothModule,
    BatteryModule,
    Date,
  ],
});

export default Widget.Window({
  monitor: 0,
  name: `bar`,
  anchor: ["top", "left", "right"],
  exclusivity: "exclusive",

  child: Widget.CenterBox({
    className: "bar",

    startWidget: Start,
    centerWidget: Center,
    endWidget: End,
  }),
});
