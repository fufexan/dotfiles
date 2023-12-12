import { Widget } from "../../imports.js";

export const Title = (player) =>
  Widget.Scrollable({
    className: "title",
    vscroll: "never",
    hscroll: "automatic",

    child: Widget.Label({
      className: "title",
      label: "Nothing playing",

      binds: [
        [
          "label",
          player,
          "track-title",
          (title) => title ?? "Nothing playing",
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

      binds: [[
        "label",
        player,
        "track-artists",
        (artists) => artists.join(", ") ?? "",
      ]],
    }),
  });
