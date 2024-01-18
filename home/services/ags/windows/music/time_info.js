import { Widget } from "../../imports.js";
import { lengthStr } from "../../utils/mpris.js";

export const PositionLabel = (player) =>
  Widget.Label({
    className: "position",
    hexpand: true,
    xalign: 0,

    setup: (self) => {
      const update = (_, time) => {
        player.length > 0
          ? self.label = lengthStr(time || player.position)
          : self.visible = !!player;
      };

      self
        .hook(player, update, "position")
        .poll(1000, update);
    },
  });

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

    onChange: ({ value }) => player.position = player.length * value,

    setup: (self) => {
      const update = () => {
        if (self.dragging) return;

        self.visible = player.length > 0;

        if (player.length > 0) {
          self.value = player.position / player.length;
        }
      };

      self
        .hook(player, update)
        .hook(player, update, "position")
        .poll(1000, update);
    },
  });

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
