import { Mpris, musicVisible, Widget } from "../../imports.js";
import { generateBackground } from "../../utils/mpris.js";

import Cover from "./cover.js";
import { Artists, Title } from "./title_artists.js";
import TimeInfo from "./time_info.js";
import Controls from "./controls.js";
import PlayerInfo from "./player_info.js";

const Info = (player) =>
  Widget.Box({
    className: "info",
    vertical: true,
    vexpand: false,
    hexpand: false,
    homogeneous: true,

    children: [
      PlayerInfo(player),
      Title(player),
      Artists(player),
      Controls(player),
      TimeInfo(player),
    ],
  });

const MusicBox = (player) =>
  Widget.Box({
    className: "music window",
    children: [
      Cover(player),
      Info(player),
    ],

    binds: [
      [
        "css",
        player,
        "cover-path",
        generateBackground,
      ],
    ],
  });

export default Widget.Window({
  monitor: 0,
  layer: "overlay",
  anchor: ["top"],
  name: "music",

  binds: [
    ["visible", musicVisible],
    [
      "child",
      Mpris,
      "players",
      (players) => {
        if (players.length == 0) return Widget.Box();
        return MusicBox(players[0]);
      },
    ],
  ],
});
