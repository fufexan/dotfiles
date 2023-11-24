import { Widget, Mpris, Variable } from "../../../imports.js";

let revealControls = Variable(false);
let player = Variable(Mpris.getPlayer(""));

const Cover = Widget.Box({
  className: "cover",

  connections: [
    [
      Mpris,
      (self) =>
        (self.css = `background-image: url('${player.value?.cover_path}');`),
    ],
  ],
});

const Title = Widget.Label({
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
            self.icon =
              "media-" +
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
          if (player.getValue() == null || player?.value.busName != busName)
            player.value = Mpris.getPlayer(busName);

          console.log(
            `player changed: ${busName}\nwe have ${Mpris.players.length} player(s)`,
          );
        },
        "player-changed",
      ],
      [
        Mpris,
        (self, busName) => {
          // music module is visible, as we have a player
          self.visible = true;

          console.log(
            `player added: ${busName}\nwe have ${Mpris.players.length} player(s)`,
          );
        },
        "player-added",
      ],
      [
        Mpris,
        (self, busName) => {
          // if we have no players, make the module invisible
          self.visible = Mpris.players.length > 0 ? true : false;

          console.log(
            `player closed: ${busName}\nwe have ${Mpris.players.length} player(s)`,
          );
        },
        "player-closed",
      ],
    ],
  }),
});
