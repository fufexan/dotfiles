import { Widget } from "../../imports.js";
import { lengthStr } from "../../utils/mpris.js";

export const PositionLabel = (player) =>
  Widget.Label({
    className: "position",
    hexpand: true,
    xalign: 0,

    properties: [["update", (label, time) => {
      player.length > 0
        ? label.label = lengthStr(time || player.position)
        : label.visible = !!player;
    }]],
  })
    .hook(player, (l, time) => l._update(l, time), "position")
    .poll(1000, (l) => l._update(l));

export const LengthLabel = (player) =>
  Widget.Label({
    className: "length",
    hexpand: true,
    xalign: 1,
  })
    .bind("visible", player, "length", (length) => length > 0)
    .bind("label", player, "length", (length) => lengthStr(length));

export const Position = (player) =>
  Widget.Slider({
    className: "position",
    draw_value: false,

    onChange: ({ value }) => {
      player.position = player.length * value;
    },

    properties: [["update", (slider) => {
      if (slider.dragging) {
        return;
      }

      slider.visible = player.length > 0;
      if (player.length > 0) {
        slider.value = player.position / player.length;
      }
    }]],
  })
    .hook(player, (self) => self._update(self))
    .hook(player, (self) => self._update(self), "position")
    .poll(1000, (self) => self._update(self));

export default (player) =>
  Widget.Box({
    vertical: true,
    vexpand: true,
    vpack: "end",

    children: [
      Widget.Box({
        hexpand: true,
        children: [
          PositionLabel(player),
          LengthLabel(player),
        ],
      }),
      Position(player),
    ],
  });
