import {
  Audio,
  Icons,
  systemMenuVisible,
  Utils,
  Widget,
} from "../../imports.js";
import Brightness from "../../services/brightness.js";

const Slider = (args) =>
  Widget.Box({
    ...args.props ?? {},
    className: args.name,

    children: [
      Widget.Button({
        onPrimaryClick: args.icon.action ?? null,
        child: Widget.Icon({
          icon: args.icon.icon ?? "",
          binds: args.icon.binds ?? [],
        }),
      }),
      Widget.Slider({
        drawValue: false,
        hexpand: true,
        binds: args.slider.binds ?? [],
        onChange: args.slider.onChange ?? null,
      }),
    ],
  });

const vol = {
  name: "volume",
  icon: {
    action: () => {
      systemMenuVisible.value = !systemMenuVisible.value;
      Utils.execAsync("pavucontrol");
    },
    binds: [["icon", Audio.speaker, "volume", (volume) => {
      const vol = volume * 100;
      const icon = [
        [101, "overamplified"],
        [67, "high"],
        [34, "medium"],
        [1, "low"],
        [0, "muted"],
      ].find(([threshold]) => threshold <= vol)[1];

      return Icons.volume[icon];
    }]],
  },
  slider: {
    binds: [[
      "value",
      Audio.speaker,
      "volume",
    ]],
    onChange: ({ value }) => Audio.speaker.volume = value,
  },
};

const brightness = {
  name: "brightness",
  icon: {
    icon: Icons.brightness,
  },
  slider: {
    binds: [[
      "value",
      Brightness,
      "screen-value",
    ]],
    onChange: ({ value }) => Brightness.screenValue(value),
  },
};

export default Widget.Box({
  className: "sliders",
  vertical: true,

  children: [
    Slider(vol),
    Slider(brightness),
  ],
});
