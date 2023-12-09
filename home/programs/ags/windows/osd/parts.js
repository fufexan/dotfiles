import { Audio } from "../../imports.js";
import Brightness from "../../services/brightness.js";
import { debounce, OsdValue, toggleOsd } from "./util.js";
import Icons from "../../icons.js";

export const brightnessIndicator = OsdValue({
  label: "Brightness",
  icon: Icons.brightness,
  connections: {
    progressConnections: [[
      Brightness,
      // I use exponential brightness changes, so this turns the raw values linear
      (self, value) => self.fraction = Math.log10((value ?? 1) * 9 + 1),
      "screen-changed",
    ]],
  },
  props: {
    connections: [[
      Brightness,
      toggleOsd,
      "screen-changed",
    ]],
  },
});

export const volumeIndicator = OsdValue({
  label: "Volume",
  icon: null,
  connections: {
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

      self.icon = Icons.volume[icon];
    }]],
  },
  props: {
    connections: [[
      Audio,
      debounce,
      "speaker-changed",
    ]],
  },
});
