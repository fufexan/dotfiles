import App from "resource:///com/github/Aylur/ags/app.js";
import { Audio, Hyprland, Widget } from "../../imports.js";

import Brightness from "../../services/brightness.js";
import Indicators from "../../services/osd.js";
import PopupWindow from "../../utils/popup_window.js";

// connections
Audio.connect("speaker-changed", () =>
  Audio.speaker.connect(
    "changed",
    () => {
      if (!App.getWindow("system-menu")?.visible) {
        Indicators.speaker();
      }
    },
  ));
Audio.connect(
  "microphone-changed",
  () => Audio.microphone.connect("changed", () => Indicators.mic()),
);

Brightness.connect("screen-changed", () => {
  if (!App.getWindow("system-menu")?.visible) {
    Indicators.display();
  }
});

let lastMonitor;

const child = () =>
  Widget.Box({
    className: "osd",

    children: [
      Widget.Overlay({
        hexpand: true,
        visible: false,
        passThrough: true,

        child: Widget.ProgressBar({
          hexpand: true,
          vertical: false,
        })
          .hook(
            Indicators,
            (self, props) => {
              self.value = props?.value ?? 0;
              self.visible = props?.showProgress ?? false;
            },
          ),

        overlays: [
          Widget.Box({
            hexpand: true,

            children: [
              Widget.Icon().hook(
                Indicators,
                (self, props) => self.icon = props?.icon ?? "",
              ),
              Widget.Box({
                hexpand: true,
              }),
            ],
          }),
        ],
      }),
    ],
  });

export default () =>
  PopupWindow({
    name: "osd",
    monitor: 0,
    layer: "overlay",
    child: child(),
    click_through: true,
    anchor: ["bottom"],
    revealerSetup: (self) =>
      self
        .hook(Indicators, (revealer, _, visible) => {
          revealer.reveal_child = visible;
        }),
  })
    .hook(
      Hyprland.active,
      (self) => {
        // prevent useless resets
        if (lastMonitor === Hyprland.active.monitor) return;

        self.monitor = Hyprland.active.monitor.id;
      },
    )
    .hook(Indicators, (win, _, visible) => {
      win.visible = visible;
    });
