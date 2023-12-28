import { Mpris, Widget } from "../../../imports.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import { findPlayer } from "../../../utils/mpris.js";

const Cover = (player) =>
  Widget.Box({ className: "cover" })
    .bind(
      "css",
      player,
      "cover-path",
      (cover) => `background-image: url('${cover ?? ""}');`,
    );

const Title = (player) =>
  Widget.Label({ className: "title module" })
    .bind(
      "label",
      player,
      "track-title",
      (title) => (title ?? "") == "Unknown title" ? "" : title,
    );

export const MusicBox = (player) =>
  Widget.Box({
    children: [
      Cover(player),
      Title(player),
    ],
  });

export default () =>
  Widget.EventBox({
    className: "music",
    onPrimaryClick: () => App.toggleWindow("music"),
  })
    .hook(
      App,
      (self, window, visible) => {
        if (window === "music") {
          self.toggleClassName("active", visible);
        }
      },
    )
    .bind("visible", Mpris, "players", (p) => p.length > 0)
    .bind("child", Mpris, "players", (players) => {
      if (players.length == 0) return Widget.Box();
      return MusicBox(findPlayer(players));
    });
