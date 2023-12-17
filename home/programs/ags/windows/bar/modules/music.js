import { App, Icons, Mpris, Variable, Widget } from "../../../imports.js";
import { mprisStateIcon } from "../../../utils/mpris.js";

const revealControls = Variable(false);

const onHover = () => revealControls.value = true;
const onHoverLost = () => revealControls.value = false;

const Cover = (player) =>
  Widget.Box({ className: "cover" })
    .bind(
      "css",
      player,
      "cover-path",
      (cover) => `background-image: url('${cover ?? ""}');`,
    );

const Title = (player) =>
  Widget.Label({ className: "title module" })
    .bind(
      "label",
      player,
      "track-title",
      (title) => (title ?? "") == "Unknown title" ? "" : title,
    );

export const Controls = (player) =>
  Widget.CenterBox({
    className: "controls",

    startWidget: Widget.Button({
      onHover,
      onHoverLost,
      onClicked: () => player.previous(),
      child: Widget.Icon(Icons.media.previous),
    }),

    centerWidget: Widget.Button({
      onHover,
      onHoverLost,
      onClicked: () => player.playPause(),

      child: Widget.Icon().bind(
        "icon",
        player,
        "play-back-status",
        mprisStateIcon,
      ),
    }),

    endWidget: Widget.Button({
      onHover,
      onHoverLost,
      onClicked: () => player.next(),
      child: Widget.Icon(Icons.media.next),
    }),
  });

export const Revealer = (player) =>
  Widget.Revealer({
    revealChild: false,
    transition: "slide_right",
    child: Controls(player),
  })
    .bind("reveal-child", revealControls);

export const MusicBox = (player) =>
  Widget.Box({
    children: [
      Cover(player),
      Title(player),
    ],
  });

const makeChildren = (players) => {
  if (players.length == 0) return [];
  return [
    MusicBox(players[0]),
    Revealer(players[0]),
  ];
};

export default Widget.EventBox({
  className: "music",

  onHover,
  onHoverLost,
  onPrimaryClick: () => App.toggleWindow("music"),

  child: Widget.Box()
    .bind("children", Mpris, "players", makeChildren)
    .bind("visible", Mpris, "players", (p) => p.length > 0),
})
  .hook(
    App,
    (self, window, visible) => {
      if (window === "music") {
        self.toggleClassName("active", visible);
      }
    },
  );
