import { Audio, Hyprland, Widget } from "../../imports.js";

import Brightness from "../../services/brightness.js";
import Indicators from "../../services/osd.js";
import PopupWindow from "../../utils/popup_window.js";

// connections
Audio.connect("speaker-changed", () =>
  Audio.speaker.connect(
    "changed",
    () => Indicators.speaker(),
  ));
Audio.connect(
  "microphone-changed",
  () => Audio.microphone.connect("changed", () => Indicators.mic()),
);

Brightness.connect("screen-changed", () => Indicators.display());

let lastMonitor;

const child = Widget.Box({
  hexpand: true,
  visible: false,
  className: "osd",

  children: [
    Widget.Icon({
      connections: [[
        Indicators,
        (self, props) => self.icon = props?.icon ?? "",
      ]],
    }),
    Widget.Box({
      hexpand: true,
      vertical: true,
      children: [
        Widget.Label({
          hexpand: false,
          truncate: "end",
          max_width_chars: 24,
          connections: [[
            Indicators,
            (self, props) => self.label = props?.label ?? "",
          ]],
        }),
        Widget.ProgressBar({
          hexpand: true,
          vertical: false,
          connections: [
            [
              Indicators,
              (self, props) => {
                self.value = props?.value ?? 0;
                self.visible = props?.showProgress ?? false;
              },
            ],
          ],
        }),
      ],
    }),
  ],
});

export const Osd = PopupWindow({
  name: "osd",
  monitor: 0,
  revealerConnections: [[Indicators, (revealer, _, visible) => {
    revealer.reveal_child = visible;
  }]],
  child,
  connections: [
    [
      Hyprland.active,
      (self) => {
        // prevent useless resets
        if (lastMonitor === Hyprland.active.monitor) return;

        self.monitor = Hyprland.monitors.find(({ name }) =>
          name === Hyprland.active.monitor
        ).id;
      },
    ],
    [Indicators, (win, _, visible) => {
      win.visible = visible;
    }],
  ],
});

export default Osd;
