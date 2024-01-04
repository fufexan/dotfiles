import { App, Battery, Icons, Utils, Widget } from "../../imports.js";
import { batteryTime } from "../../utils/battery.js";

const batteryEnergy = () => {
  return Battery.energyRate > 0.1 ? `${Battery.energyRate.toFixed(1)} W ` : "";
};

const BatteryIcon = () =>
  Widget.Icon()
    .bind("icon", Battery, "percent", () => Battery.iconName)
    .bind("tooltip-text", Battery, "energy-rate", batteryEnergy);

const BatteryPercent = () =>
  Widget.Label()
    .bind(
      "label",
      Battery,
      "percent",
      (percent) => `${percent}%`,
    );

const BatteryTime = () =>
  Widget.Label({
    className: "time",
    vexpand: true,
    vpack: "center",
  })
    .bind("label", Battery, "charging", batteryTime)
    .bind("label", Battery, "energy-rate", batteryTime);

const BatteryBox = () =>
  Widget.Box({
    className: "battery-box",
    visible: Battery.available,

    children: [
      BatteryIcon(),
      BatteryPercent(),
      BatteryTime(),
    ],
  });

const PowerButton = () =>
  Widget.Button({
    className: "button disabled",
    hexpand: true,
    hpack: "end",

    onPrimaryClick: () => {
      App.toggleWindow("system-menu");
      Utils.exec("wlogout");
    },

    child: Widget.Icon(Icons.powerButton),
  });

export default () =>
  Widget.Box({
    className: "battery-info",

    children: [
      BatteryBox(),
      PowerButton(),
    ],
  });
