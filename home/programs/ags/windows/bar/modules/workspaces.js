import { Widget, Hyprland, Utils } from "../../../imports.js";
const { execAsync } = Utils;

const dispatch = (ws) => execAsync([`hyprctl dispatch workspace ${ws}`]);

const makeWorkspaces = () => {
  let workspaces = Array.from(Hyprland.workspaces);

  return workspaces
    .sort((x, y) => {
      return x.id - y.id;
    })
    .filter((x) => {
      return x.name.indexOf("special") == -1;
    })
    .map((i) =>
      Widget.Button({
        setup: (btn) => (btn.id = i.id),
        on_clicked: () => dispatch(i.id),

        child: Widget.Label({
          label: `${i.id}`,
          vpack: "center",
        }),

        connections: [
          [
            Hyprland,
            (btn) =>
              btn.toggleClassName(
                "focused",
                Hyprland.active.workspace.id === i.id,
              ),
          ],
        ],
      }),
    );
};

function update(self) {
  self.children = makeWorkspaces();
}

export const Workspaces = Widget.EventBox({
  onScrollUp: () => dispatch("+1"),
  onScrollDown: () => dispatch("-1"),

  child: Widget.Box({
    className: "workspaces",

    children: makeWorkspaces(),

    connections: [
      [Hyprland, update, "workspace-added"],
      [Hyprland, update, "workspace-removed"],
    ],
  }),
});
