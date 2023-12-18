import { Widget } from "../../imports.js";

export const Title = (player) =>
  Widget.Scrollable({
    className: "title",
    vscroll: "never",
    hscroll: "automatic",

    child: Widget.Label({
      className: "title",
      label: "Nothing playing",
    })
      .bind(
        "label",
        player,
        "track-title",
        (title) => title ?? "Nothing playing",
      ),
  });

export const Artists = (player) =>
  Widget.Scrollable({
    className: "artists",
    vscroll: "never",
    hscroll: "automatic",

    child: Widget.Label({ className: "artists" })
      .bind(
        "label",
        player,
        "track-artists",
        (artists) => artists.join(", ") ?? "",
      ),
  });
