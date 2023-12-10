import { Mpris, Widget } from "../../imports.js";

export const Title = (player) =>
  Widget.Scrollable({
    className: "title",
    vscroll: "never",
    hscroll: "automatic",

    child: Widget.Label({
      className: "title",
      label: "Nothing playing",

      connections: [
        [
          Mpris,
          (self) => self.label = player.track_title ?? "Nothing playing",
          "changed",
        ],
      ],
    }),
  });

export const Artists = (player) =>
  Widget.Scrollable({
    className: "artists",
    vscroll: "never",
    hscroll: "automatic",

    child: Widget.Label({
      className: "artists",

      connections: [[
        Mpris,
        (self) =>
          self.label = player.track_artists.join(", ") ??
            "Nothing playing",
        "changed",
      ]],
    }),
  });
