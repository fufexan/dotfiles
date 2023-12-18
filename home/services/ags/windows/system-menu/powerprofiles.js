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
          setup: args.iconSetup,
        }),
        Widget.Label({
          label: args.label ?? "",
          setup: args.labelSetup,
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

const ActiveProfile = Profile({
  props: {
    className: "current-profile",
  },
  primaryClickAction: () => showList.value = !showList.value,
  iconSetup: (self) => self.bind("icon", PowerProfiles, "icon"),
  labelSetup: (self) =>
    self.bind("label", PowerProfiles, "active-profile", prettyName),
});

const ProfileRevealer = Widget.Revealer({
  revealChild: false,
  transition: "slide_down",

  child: Widget.Box({
    className: "options",
    vertical: true,
  })
    .bind(
      "children",
      PowerProfiles,
      "profiles",
      makeProfiles,
    ),
})
  .bind("reveal-child", showList);

export default Widget.Box({
  className: "power-profiles",
  vertical: true,

  children: [
    Widget.Box({
      vertical: true,
      children: [
        ActiveProfile,
        ProfileRevealer,
      ],
    }),
  ],
});
