import { Mpris, Widget } from "../../imports.js";
import Gtk from "gi://Gtk?version=3.0";

export default Widget.CenterBox({
  className: "controls",
  halign: Gtk.Align.CENTER,

  startWidget: Widget.Button({
    onClicked: () => player.value?.previous(),
    child: Widget.Icon("media-skip-backward"),
  }),

  centerWidget: Widget.Button({
    onClicked: () => player.value?.playPause(),

    child: Widget.Icon({
      connections: [
        [
          Mpris,
          (self) => {
            self.icon = "media-" +
              (player.value?.playBackStatus == "Playing" ? "pause" : "play");
          },
          "changed",
        ],
      ],
    }),
  }),

  endWidget: Widget.Button({
    onClicked: () => player.value?.next(),
    child: Widget.Icon("media-skip-forward"),
  }),
});
