import { Gtk, Icons, Mpris, Utils, Widget } from "../../imports.js";

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

        connections: [[
          Mpris,
          (self) =>
            self.icon = Utils.lookUpIcon(player.entry ?? "")
              ? player.entry
              : Icons.media.player,
          "player-changed",
        ]],
      }),
    ],
  });
