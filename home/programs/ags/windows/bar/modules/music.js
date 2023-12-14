import { App, Icons, Mpris, Variable, Widget } from "../../../imports.js";
import { mprisStateIcon } from "../../../utils/mpris.js";

const revealControls = Variable(false);

const Cover = (player) =>
  Widget.Box({
    className: "cover",

    binds: [[
      "css",
      player,
      "cover-path",
      (cover) => `background-image: url('${cover ?? ""}');`,
    ]],
  });

const Title = (player) =>
  Widget.Label({
    className: "title module",

    binds: [[
      "label",
      player,
      "track-title",
      (title) => title ?? "",
    ]],
  });

export const Controls = (player) =>
  Widget.CenterBox({
    className: "controls",

    startWidget: Widget.Button({
      onHover: () => revealControls.value = true,
      onHoverLost: () => revealControls.value = false,
      onClicked: () => player.previous(),
      child: Widget.Icon(Icons.media.previous),
    }),

    centerWidget: Widget.Button({
      onHover: () => revealControls.value = true,
      onHoverLost: () => revealControls.value = false,
      onClicked: () => player.playPause(),

      child: Widget.Icon({
        binds: [[
          "icon",
          player,
          "play-back-status",
          mprisStateIcon,
        ]],
      }),
    }),

    endWidget: Widget.Button({
      onHover: () => revealControls.value = true,
      onHoverLost: () => revealControls.value = false,
      onClicked: () => player.next(),
      child: Widget.Icon(Icons.media.next),
    }),
  });

export const Revealer = (player) =>
  Widget.Revealer({
    revealChild: false,
    transition: "slide_right",
    child: Controls(player),

    binds: [["reveal-child", revealControls]],
  });

export const MusicBox = (player) =>
  Widget.Box({
    children: [
      Cover(player),
      Title(player),
    ],
  });

export default Widget.EventBox({
  className: "music",

  onPrimaryClick: () => App.toggleWindow("music"),
  onHover: () => revealControls.value = true,
  onHoverLost: () => revealControls.value = false,

  connections: [[
    App,
    (self, window, visible) => {
      if (window === "music") {
        self.toggleClassName("active", visible);
      }
    },
  ]],

  child: Widget.Box({
    binds: [
      ["children", Mpris, "players", (players) => {
        if (players.length == 0) return [];
        return [
          MusicBox(players[0]),
          Revealer(players[0]),
        ];
      }],
      [
        "visible",
        Mpris,
        "players",
        (p) => p.length > 0,
      ],
    ],
  }),
});
