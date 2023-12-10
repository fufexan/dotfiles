import {
  Icons,
  Mpris,
  musicVisible,
  Variable,
  Widget,
} from "../../../imports.js";

const revealControls = Variable(false);

const Cover = (player) =>
  Widget.Box({
    className: "cover",

    connections: [
      [
        Mpris,
        (self) =>
          self.css = `background-image: url('${player.cover_path ?? ""}');`,
      ],
    ],
  });

const Title = (player) =>
  Widget.Label({
    className: "title module",

    connections: [
      [Mpris, (self) => self.label = player.track_title ?? ""],
    ],
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
        connections: [
          [
            Mpris,
            (self) => {
              const state = player.playBackStatus == "Playing"
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

    connections: [
      [revealControls, (self) => self.revealChild = revealControls.value],
    ],
  });

export const MusicBox = (player) =>
  Widget.Box({
    children: [
      Cover(player),
      Title(player),
    ],
  });

export default Widget.EventBox({
  onPrimaryClick: () => musicVisible.value = !musicVisible.value,
  onHover: () => revealControls.value = true,
  onHoverLost: () => revealControls.value = false,

  child: Widget.Box({
    className: "music",

    binds: [
      ["children", Mpris, "players", (players) => {
        if (players.length == 0) return [];
        return [
          Revealer(players[0]),
          MusicBox(players[0]),
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
