import { Gtk, Icons, Utils, Widget } from "../../imports.js";

export default (player) =>
  Widget.Box({
    className: "player-info",
    vexpand: true,
    valign: Gtk.Align.START,

    children: [
      Widget.Icon({
        hexpand: true,
        halign: Gtk.Align.END,
        className: "player-icon",
        tooltipText: player.identity ?? "",

        binds: [[
          "icon",
          player,
          "entry",
          (entry) => Utils.lookUpIcon(entry ?? "") ? entry : Icons.media.player,
        ]],
      }),
    ],
  });
