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
  }).poll(2000, props.boxpoll);

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

  boxpoll: (self) =>
    Utils.execAsync([
      "sh",
      "-c",
      "lscpu --parse=MHZ",
    ])
      .then((r) => {
        const mhz = r.split("\n").slice(4);
        const freq = mhz.reduce((acc, e) => acc + Number(e), 0) / mhz.length;
        self.tooltipText = Math.round(freq) + " MHz";
      })
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

  boxpoll: (self) =>
    Utils.execAsync([
      "sh",
      "-c",
      "free --si -h | tail -2 | head -1 | awk '{print $3}'",
    ])
      .then((r) => self.tooltipText = r)
      .catch((err) => print(err)),
};

export default () =>
  Widget.EventBox({
    onPrimaryClick: () => Utils.execAsync(["missioncenter"]),

    child: Widget.Box({
      className: "system-info module",

      children: [
        Indicator(cpu),
        Indicator(ram),
      ],
    }),
  });
