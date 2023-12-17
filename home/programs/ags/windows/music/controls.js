import { Icons, Widget } from "../../imports.js";
import { mprisStateIcon } from "../../utils/mpris.js";

export default (player) =>
  Widget.CenterBox({
    className: "controls",
    hpack: "center",

    startWidget: Widget.Button({
      onClicked: () => player.previous(),
      child: Widget.Icon(Icons.media.previous),
    }),

    centerWidget: Widget.Button({
      onClicked: () => player.playPause(),

      child: Widget.Icon().bind(
        "icon",
        player,
        "play-back-status",
        mprisStateIcon,
      ),
    }),

    endWidget: Widget.Button({
      onClicked: () => player.next(),
      child: Widget.Icon(Icons.media.next),
    }),
  });
