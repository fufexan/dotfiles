import { Utils, Widget } from "../../../imports.js";
const { execAsync } = Utils;

export const SystemInfo = Widget.Box({
  className: "system-info module",

  children: [
    Widget.Box({
      vertical: true,
      children: [
        Widget.Label({
          className: "type",
          label: "CPU",
        }),
        Widget.Label({
          className: "value",

          connections: [
            [
              2000,
              (self) =>
                execAsync([
                  "sh",
                  "-c",
                  `top -bn1 | rg '%Cpu' | tail -1 | awk '{print 100-$8}'`,
                ])
                  .then((r) => (self.label = Math.round(Number(r)) + "%"))
                  .catch((err) => print(err)),
            ],
          ],
        }),
      ],
    }),
    Widget.Box({
      vertical: true,
      children: [
        Widget.Label({
          className: "type",
          label: "MEM",
        }),
        Widget.Label({
          className: "value",

          connections: [
            [
              2000,
              (self) =>
                execAsync([
                  "sh",
                  "-c",
                  `free | tail -2 | head -1 | awk '{print $3/$2*100}'`,
                ])
                  .then((r) => (self.label = Math.round(Number(r)) + "%"))
                  .catch((err) => print(err)),
            ],
          ],
        }),
      ],
    }),
  ],
});
