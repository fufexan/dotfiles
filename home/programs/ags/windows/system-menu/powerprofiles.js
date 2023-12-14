import { Variable, Widget } from "../../imports.js";
import PowerProfiles from "../../services/powerprofiles.js";

const showList = Variable(false);
const Profile = (args) =>
  Widget.EventBox({
    onPrimaryClick: args.primaryClickAction,
    hexpand: true,
    child: Widget.Box({
      ...args.props ?? {},
      hexpand: true,
      hpack: "start",

      children: [
        Widget.Icon({
          icon: args.icon ?? "",
          binds: args.iconBinds ?? [],
        }),
        Widget.Label({
          label: args.label ?? "",
          binds: args.labelBinds ?? [],
        }),
      ],
    }),
  });

const prettyName = (n) =>
  n.charAt(0).toUpperCase() +
  n.substring(1).replace("-", " ");

const makeProfiles = (profiles) =>
  profiles.map((e) =>
    Profile({
      primaryClickAction: () => {
        PowerProfiles.activeProfile = e.profile;
        showList.value = false;
      },
      icon: e.icon,
      label: prettyName(e.profile),
    })
  );

export default Widget.Box({
  className: "power-profiles",
  vertical: true,

  children: [
    Widget.Box({
      vertical: true,
      children: [
        Profile({
          props: {
            className: "current-profile",
          },
          primaryClickAction: () => showList.value = !showList.value,
          iconBinds: [["icon", PowerProfiles, "icon"]],
          labelBinds: [["label", PowerProfiles, "active-profile", prettyName]],
        }),
        Widget.Revealer({
          revealChild: false,
          transition: "slide_down",

          binds: [["reveal-child", showList]],

          child: Widget.Box({
            className: "options",
            vertical: true,

            binds: [[
              "children",
              PowerProfiles,
              "profiles",
              makeProfiles,
            ]],
          }),
        }),
      ],
    }),
  ],
});
