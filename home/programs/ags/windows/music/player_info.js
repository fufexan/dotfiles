import { Icons, Utils, Widget } from "../../imports.js";

export default (player) =>
  Widget.Box({
    className: "player-info",
    vexpand: true,
    vpack: "start",

    children: [
      Widget.Icon({
        hexpand: true,
        hpack: "end",
        className: "player-icon",
        tooltipText: player.identity ?? "",
      })
        .bind(
          "icon",
          player,
          "entry",
          (entry) => {
            // the Spotify icon is called spotify-client
            if (entry == "spotify") entry = "spotify-client";
            return Utils.lookUpIcon(entry ?? "") ? entry : Icons.media.player;
          },
        ),
    ],
  });
