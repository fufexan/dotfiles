import { Mpris, Widget } from "../../imports.js";
import Gtk from "gi://Gtk?version=3.0";
import Icons from "../../icons.js";

export default Widget.CenterBox({
  className: "controls",
  halign: Gtk.Align.CENTER,

  startWidget: Widget.Button({
    onClicked: () => player.value?.previous(),
    child: Widget.Icon(Icons.media.previous),
  }),

  centerWidget: Widget.Button({
    onClicked: () => player.value?.playPause(),

    child: Widget.Icon({
      connections: [
        [
          Mpris,
          (self) => {
            const state = player.value?.playBackStatus == "Playing"
              ? "pause"
              : "play";
            self.icon = Icons.media[state];
          },
          "changed",
        ],
      ],
    }),
  }),

  endWidget: Widget.Button({
    onClicked: () => player.value?.next(),
    child: Widget.Icon(Icons.media.next),
  }),
});
