import { Mpris, Variable, Widget } from "../../../imports.js";

let revealControls = Variable(false);
let player = Variable(Mpris.getPlayer(""));

const Cover = Widget.Box({
  className: "cover",

  connections: [
    [
      Mpris,
      (
        self,
      ) => (self.css = `background-image: url('${player.value?.cover_path}');`),
    ],
  ],
});

const Title = Widget.Label({
  className: "title module",

  connections: [
    [Mpris, (self) => (self.label = player.value?.track_title ?? "")],
  ],
});

const Controls = Widget.CenterBox({
  className: "controls",

  startWidget: Widget.Button({
    onHover: () => (revealControls.value = true),
    onHoverLost: () => (revealControls.value = false),
    onClicked: () => player.value?.previous(),
    child: Widget.Icon("media-skip-backward"),
  }),

  centerWidget: Widget.Button({
    onHover: () => (revealControls.value = true),
    onHoverLost: () => (revealControls.value = false),
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
    onHover: () => (revealControls.value = true),
    onHoverLost: () => (revealControls.value = false),
    onClicked: () => player.value?.next(),
    child: Widget.Icon("media-skip-forward"),
  }),
});

export const Music = Widget.EventBox({
  onHover: () => (revealControls.value = true),
  onHoverLost: () => (revealControls.value = false),

  child: Widget.Box({
    className: "music",

    children: [
      Widget.Box({
        children: [Cover, Title],
      }),
      Widget.Revealer({
        revealChild: false,
        transition: "slide_right",
        child: Controls,

        connections: [
          [revealControls, (self) => (self.revealChild = revealControls.value)],
        ],
      }),
    ],

    connections: [
      [
        Mpris,
        (_, busName) => {
          // don't replace the same player
          if (player.getValue() == null || player?.value.busName != busName) {
            player.value = Mpris.getPlayer(busName);
          }
        },
        "player-changed",
      ],
      [
        Mpris,
        (self, _) => {
          // music module is visible, as we have a player
          self.visible = true;
        },
        "player-added",
      ],
      [
        Mpris,
        (self, _) => {
          // if we have no players, make the module invisible
          self.visible = Mpris.players.length > 0 ? true : false;
        },
        "player-closed",
      ],
    ],
  }),
});
