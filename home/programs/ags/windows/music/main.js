import { Mpris, musicVisible, Utils, Widget } from "../../imports.js";
import GLib from "gi://GLib";

import Cover from "./cover.js";
import { Artists, Title } from "./title_artists.js";
import TimeInfo from "./time_info.js";
import Controls from "./controls.js";
import PlayerInfo from "./player_info.js";

const MEDIA_CACHE_PATH = Utils.CACHE_DIR + "/media";
const blurredPath = MEDIA_CACHE_PATH + "/blurred";

const generateBackground = (box, cover_path) => {
  const url = cover_path;
  if (!url) return;

  const blurred = blurredPath +
    url.substring(MEDIA_CACHE_PATH.length);

  if (GLib.file_test(blurred, GLib.FileTest.EXISTS)) {
    box.setCss(`background: url('${blurred}')`);
  }

  Utils.ensureDirectory(blurredPath);
  Utils.execAsync(["convert", url, "-blur", "0x22", blurred])
    .then(() => box.setCss(`background: url('${blurred}')`))
    .catch(print);
};

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

    connections: [
      [
        player,
        generateBackground,
        "notify::cover-path",
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
