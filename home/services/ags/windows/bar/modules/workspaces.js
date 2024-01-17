import { Hyprland, Widget } from "../../../imports.js";
import {
  added,
  dispatch,
  focusedSwitch,
  getLastWorkspaceId,
  removed,
  workspaceActive,
} from "../../../utils/hyprland.js";

globalThis.hyprland = Hyprland;

const makeWorkspaces = () =>
  [...Array(10)].map((_, i) => {
    const id = i + 1;

    return Widget.Button({
      onPrimaryClick: () => dispatch(id),
      visible: getLastWorkspaceId() >= id,

      setup: (self) => {
        const ws = Hyprland.getWorkspace(id);
        self.id = id;
        self.active = workspaceActive(id);
        self.monitor = {};

        if (self.active) {
          self.monitor = {
            id: ws.monitorID,
            name: ws.monitor,
          };
          self.toggleClassName(`monitor${self.monitor?.id ?? ""}`, true);
        }
      },
    });
  });

export default () =>
  Widget.EventBox({
    onScrollUp: () => dispatch("+1"),
    onScrollDown: () => dispatch("-1"),

    child: Widget.Box({
      className: "workspaces module",

      // The Hyprland service is ready later than ags is done parsing the config,
      // so only build the widget when we receive a signal from it.
      setup: (self) => {
        const connID = Hyprland.connect("notify::workspaces", () => {
          Hyprland.disconnect(connID);

          self.children = makeWorkspaces();
          self.lastFocused = Hyprland.active.workspace.id;
          self.biggestId = getLastWorkspaceId();
          self
            .hook(Hyprland.active.workspace, focusedSwitch)
            .hook(Hyprland, added, "workspace-added")
            .hook(Hyprland, removed, "workspace-removed");
        });
      },
    }),
  });
