import { Widget } from "../../imports.js";
import Gtk from "gi://Gtk?version=3.0";

function lengthStr(length) {
  const min = Math.floor(length / 60);
  const sec = Math.floor(length % 60);
  const sec0 = sec < 10 ? "0" : "";
  return `${min}:${sec0}${sec}`;
}

export const PositionLabel = Widget.Label({
  className: "position",
  hexpand: true,
  xalign: 0,

  properties: [["update", (label, time) => {
    player.value.length > 0
      ? label.label = lengthStr(time || player.value.position)
      : label.visible = !!player.value;
  }]],

  connections: [
    [player.value, (l, time) => l._update(l, time), "position"],
    [1000, (l) => l._update(l)],
  ],
});

export const LengthLabel = Widget.Label({
  className: "length",
  hexpand: true,
  xalign: 1,

  connections: [[player.value, (label) => {
    player.value.length > 0
      ? label.label = lengthStr(player.value.length)
      : label.visible = !!player.value;
  }]],
});

export const Position = Widget.Slider({
  className: "position",
  draw_value: false,

  on_change: ({ value }) => {
    player.value.position = player.value.length * value;
  },

  properties: [["update", (slider) => {
    if (slider.dragging) {
      return;
    }

    slider.visible = player.value.length > 0;
    if (player.value.length > 0) {
      slider.value = player.value.position / player.value.length;
    }
  }]],

  connections: [
    [player.value, (self) => self._update(self)],
    [player.value, (self) => self._update(self), "position"],
    [1000, (self) => self._update(self)],
  ],
});

export default Widget.Box({
  vertical: true,
  vexpand: true,
  valign: Gtk.Align.END,

  children: [
    Widget.Box({
      hexpand: true,
      children: [
        PositionLabel,
        LengthLabel,
      ],
    }),
    Position,
  ],
});
