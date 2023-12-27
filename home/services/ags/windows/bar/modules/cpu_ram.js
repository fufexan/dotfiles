import { Utils, Widget } from "../../../imports.js";

const Indicator = (props) =>
  Widget.Box({
    vertical: true,
    vexpand: true,
    vpack: "center",

    children: [
      Widget.Label({
        className: "type",
        label: props.type,
      }),
      Widget.Label({ className: "value" })
        .poll(2000, props.poll),
    ],
  });

const cpu = {
  type: "CPU",
  poll: (self) =>
    Utils.execAsync([
      "sh",
      "-c",
      `top -bn1 | rg '%Cpu' | tail -1 | awk '{print 100-$8}'`,
    ])
      .then((r) => (self.label = Math.round(Number(r)) + "%"))
      .catch((err) => print(err)),
};

const ram = {
  type: "MEM",
  poll: (self) =>
    Utils.execAsync([
      "sh",
      "-c",
      `free | tail -2 | head -1 | awk '{print $3/$2*100}'`,
    ])
      .then((r) => (self.label = Math.round(Number(r)) + "%"))
      .catch((err) => print(err)),
};

export default () =>
  Widget.Box({
    className: "system-info module",

    children: [
      Indicator(cpu),
      Indicator(ram),
    ],
  });
