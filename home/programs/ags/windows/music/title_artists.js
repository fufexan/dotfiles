import { Mpris, Widget } from "../../imports.js";

export const Title = Widget.Scrollable({
  className: "title",
  vscroll: "never",
  hscroll: "automatic",

  child: Widget.Label({
    className: "title",
    label: "Nothing playing",

    connections: [
      [
        Mpris,
        (self) => self.label = player.value?.track_title ?? "Nothing playing",
        "changed",
      ],
    ],
  }),
});

export const Artists = Widget.Scrollable({
  className: "artists",
  vscroll: "never",
  hscroll: "automatic",

  child: Widget.Label({
    className: "artists",

    connections: [[
      Mpris,
      (self) =>
        self.label = player.value?.track_artists.join(", ") ??
          "Nothing playing",
      "changed",
    ]],
  }),
});
