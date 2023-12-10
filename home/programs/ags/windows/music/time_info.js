import { Widget } from "../../imports.js";
import Gtk from "gi://Gtk?version=3.0";

function lengthStr(length) {
  const min = Math.floor(length / 60);
  const sec = Math.floor(length % 60);
  const sec0 = sec < 10 ? "0" : "";
  return `${min}:${sec0}${sec}`;
}

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

    connections: [
      [player, (l, time) => l._update(l, time), "position"],
      [1000, (l) => l._update(l)],
    ],
  });

export const LengthLabel = (player) =>
  Widget.Label({
    className: "length",
    hexpand: true,
    xalign: 1,

    connections: [[player, (label) => {
      player.length > 0
        ? label.label = lengthStr(player.length)
        : label.visible = !!player;
    }]],
  });

export const Position = (player) =>
  Widget.Slider({
    className: "position",
    draw_value: false,

    on_change: ({ value }) => {
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

    connections: [
      [player, (self) => self._update(self)],
      [player, (self) => self._update(self), "position"],
      [1000, (self) => self._update(self)],
    ],
  });

export default (player) =>
  Widget.Box({
    vertical: true,
    vexpand: true,
    valign: Gtk.Align.END,

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
