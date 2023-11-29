import { Hyprland, Utils, Variable, Widget } from "../../../imports.js";
const { execAsync } = Utils;

const dispatch = (ws) =>
  execAsync(["sh", "-c", `hyprctl dispatch workspace ${ws}`]);

const monitors = Variable(Hyprland.monitors);

const getMonitorId = (workspace) => {
  let monitor = monitors.value.findIndex((e) => e.name == workspace?.monitor);

  if (monitor == -1) return "";

  return `monitor${monitor}`;
};

const getLastWorkspaceId = () =>
  Hyprland.workspaces
    .sort((x, y) => {
      return x.id - y.id;
    })
    .filter((x) => {
      return x.name.indexOf("special") == -1;
    })
    .slice(-1)[0].id;

const makeWorkspaces = () =>
  [...Array(getLastWorkspaceId())].map((_, i) => {
    let id = i + 1;

    return Widget.Button({
      setup: (btn) => (btn.id = id),
      on_clicked: () => dispatch(id),

      className: getMonitorId(Hyprland.getWorkspace(id)),

      connections: [
        [
          Hyprland,
          (btn) => {
            btn.toggleClassName("focused", Hyprland.active.workspace.id === id);
          },
        ],
      ],
    });
  });

function update(self) {
  self.children = makeWorkspaces();
}

export const Workspaces = Widget.EventBox({
  onScrollUp: () => dispatch("+1"),
  onScrollDown: () => dispatch("-1"),

  child: Widget.Box({
    className: "workspaces module",

    children: makeWorkspaces(),

    connections: [
      [Hyprland, update, "workspace-added"],
      [Hyprland, update, "workspace-removed"],
      [Hyprland, (_) => (monitors.value = Hyprland.monitors), "monitor-added"],
      [
        Hyprland,
        (_) => (monitors.value = Hyprland.monitors),
        "monitor-removed",
      ],
    ],
  }),
});
