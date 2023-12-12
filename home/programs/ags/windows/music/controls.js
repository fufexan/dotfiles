import { Gtk, Icons, Widget } from "../../imports.js";
import { mprisStateIcon } from "../../utils/mpris.js";

export default (player) =>
  Widget.CenterBox({
    className: "controls",
    halign: Gtk.Align.CENTER,

    startWidget: Widget.Button({
      onClicked: () => player.previous(),
      child: Widget.Icon(Icons.media.previous),
    }),

    centerWidget: Widget.Button({
      onClicked: () => player.playPause(),

      child: Widget.Icon({
        binds: [
          [
            "icon",
            player,
            "play-back-status",
            mprisStateIcon,
          ],
        ],
      }),
    }),

    endWidget: Widget.Button({
      onClicked: () => player.next(),
      child: Widget.Icon(Icons.media.next),
    }),
  });
