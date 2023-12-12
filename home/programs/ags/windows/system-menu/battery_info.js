import {
  Battery,
  Icons,
  systemMenuVisible,
  Utils,
  Widget,
} from "../../imports.js";

const batteryEnergy = () => {
  return Battery.energyRate > 0.1 ? `${Battery.energyRate.toFixed(1)} W ` : "";
};

const BatteryIcon = Widget.Icon({
  binds: [
    ["icon", Battery, "percent", () => Battery.iconName],
    ["tooltip-text", Battery, "energy-rate", batteryEnergy],
  ],
});

const BatteryPercent = Widget.Label({
  binds: [[
    "label",
    Battery,
    "percent",
    (percent) => `${percent}%`,
  ]],
});

const toTime = (time) => {
  const MINUTE = 60;
  const HOUR = MINUTE * 60;

  if (time > 24 * HOUR) return "";

  const hours = Math.round(time / HOUR);
  const minutes = Math.round((time - hours * HOUR) / MINUTE);

  const hoursDisplay = hours > 0 ? `${hours}h ` : "";
  const minutesDisplay = minutes > 0 ? `${minutes}m ` : "";

  return `${hoursDisplay}${minutesDisplay}`;
};

const batteryTime = () => {
  return Battery.timeRemaining > 0 && toTime(Battery.timeRemaining) != ""
    ? `${toTime(Battery.timeRemaining)}remaining`
    : "";
};

const BatteryTime = Widget.Label({
  className: "time",
  vexpand: true,
  vpack: "center",

  binds: [
    ["label", Battery, "charging", batteryTime],
    ["label", Battery, "energy-rate", batteryTime],
  ],
});

const BatteryBox = Widget.Box({
  className: "battery-box",
  visible: Battery.available,

  children: [
    BatteryIcon,
    BatteryPercent,
    BatteryTime,
  ],
});

const PowerButton = Widget.Button({
  className: "button disabled",
  hexpand: true,
  hpack: "end",

  onPrimaryClick: () => {
    systemMenuVisible.value = !systemMenuVisible.value;
    Utils.exec("wlogout");
  },

  child: Widget.Icon(Icons.powerButton),
});

export default Widget.Box({
  className: "battery-info",

  children: [
    BatteryBox,
    PowerButton,
  ],
});
