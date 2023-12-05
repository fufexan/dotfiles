import { Audio, Utils, Variable, Widget } from "../../imports.js";
import Brightness from "../../services/brightness.js";
import GLib from "gi://GLib";

let reveal = Variable(false);

let debounceTimer = Date.now();

let debounce = (self) => {
  let date = Date.now();
  if (date - debounceTimer < 50) {
    debounceTimer = date;
    return;
  }
  return toggleOsd(self);
};

// -(number of osd boxes), as toggleOsd will be run once for each of them by the connection
// TODO: find a less hackier way
let timePassed = -2;
let timeout = null;

// TODO: close all other OSDs when one is toggled
let toggleOsd = (self) => {
  // first-run
  if (timePassed < 0) {
    timePassed++;
    return;
  }

  self.visible = true;
  reveal.value = true;

  timePassed = 1500;
  if (timeout) GLib.source_remove(timeout);
  timeout = Utils.timeout(timePassed, () => {
    self.visible = false;
    reveal.value = false;
  });
};

const OsdValue = (
  name,
  icon,
  connections,
  props = {},
) =>
  Widget.Box({
    ...props,
    hexpand: true,
    visible: false,
    className: "osd",

    children: [
      Widget.Icon({
        icon: icon ?? "",
        connections: connections?.iconConnections ?? [],
      }),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Label({
            hexpand: false,
            label: `${name}`,
            truncate: "end",
            max_width_chars: 24,
            connections: connections?.labelConnections ?? [],
          }),
          Widget.ProgressBar({
            hexpand: true,
            vertical: false,
            connections: connections?.progressConnections ?? [],
          }),
        ],
      }),
    ],
  });

const brightnessIndicator = OsdValue(
  "Brightness",
  "display-brightness-symbolic",
  {
    progressConnections: [[
      Brightness,
      // I use exponential brightness changes, so this turns the raw values linear
      (self, value) => self.fraction = Math.log10((value ?? 1) * 100) - 1,
      "screen-changed",
    ]],
  },
  {
    connections: [[
      Brightness,
      toggleOsd,
      "screen-changed",
    ]],
  },
);

const volumeIndicator = OsdValue("Volume", null, {
  labelConnections: [[Audio, (label) => {
    label.label = `${Audio.speaker?.description ?? "Volume"}`;
  }]],
  progressConnections: [[Audio, (progress) => {
    const updateValue = Audio.speaker?.volume;
    if (!isNaN(updateValue)) progress.value = updateValue;
  }]],
  iconConnections: [[Audio, (self) => {
    const vol = Audio.speaker.volume * 100;
    const icon = [
      [101, "overamplified"],
      [67, "high"],
      [34, "medium"],
      [1, "low"],
      [0, "muted"],
    ].find(([threshold]) => threshold <= vol)[1];

    self.icon = `audio-volume-${icon}-symbolic`;
  }]],
}, {
  connections: [[
    Audio,
    debounce,
    "speaker-changed",
  ]],
});

const OsdContainer = Widget.Box({
  className: "osd-container",
  visible: false,
  children: [
    brightnessIndicator,
    volumeIndicator,
  ],
});

globalThis.osdcontainer = OsdContainer;

export const Osd = (monitor = 0) =>
  Widget.Window({
    monitor,
    name: `osd${monitor}`,
    layer: "overlay",
    visible: false,

    child: OsdContainer,
    binds: [["visible", reveal]],
  });

export default Osd;
