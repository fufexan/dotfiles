import { Utils, Widget } from "../../imports.js";
import GLib from "gi://GLib";

import Cover from "./cover.js";
import { Artists, Title } from "./title_artists.js";
import TimeInfo from "./time_info.js";
import Controls from "./controls.js";
import PlayerInfo from "./player_info.js";

const MEDIA_CACHE_PATH = Utils.CACHE_DIR + "/media";
const blurredPath = MEDIA_CACHE_PATH + "/blurred";

const generateBackground = (box) => {
  const url = player.value.cover_path;
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

const Info = Widget.Box({
  className: "info",
  vertical: true,
  vexpand: false,
  hexpand: false,
  homogeneous: true,

  children: [
    PlayerInfo,
    Title,
    Artists,
    Controls,
    TimeInfo,
  ],
});

const MusicBox = Widget.Box({
  className: "music window",
  children: [
    Cover,
    Info,
  ],

  connections: [
    [
      player.value,
      generateBackground,
      "notify::cover-path",
    ],
  ],
});

export const Music = Widget.Window({
  monitor: 0,
  layer: "overlay",
  anchor: ["top"],
  name: "music",

  child: MusicBox,
  binds: [["visible", musicVisible]],
});

export default Music;
