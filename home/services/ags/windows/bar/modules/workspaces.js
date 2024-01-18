import { Hyprland, Widget } from "../../../imports.js";
import {
  added,
  changeWorkspace,
  DEFAULT_MONITOR,
  focusedSwitch,
  getLastWorkspaceId,
  moveWorkspace,
  removed,
  workspaceActive,
} from "../../../utils/hyprland.js";

globalThis.hyprland = Hyprland;

const makeWorkspaces = () =>
  [...Array(10)].map((_, i) => {
    const id = i + 1;

    return Widget.Button({
      onPrimaryClick: () => changeWorkspace(id),

      visible: getLastWorkspaceId() >= id,

      setup: (self) => {
        const ws = Hyprland.getWorkspace(id);
        self.id = id;
        self.active = workspaceActive(id);
        self.monitor = DEFAULT_MONITOR;

        if (self.active) {
          self.monitor = {
            name: ws?.monitor ?? DEFAULT_MONITOR.name,
            id: ws?.monitorID ?? DEFAULT_MONITOR.id,
          };
          self.toggleClassName(`monitor${self.monitor.id}`, true);
        }
      },
    });
  });

export default () =>
  Widget.EventBox({
    onScrollUp: () => changeWorkspace("+1"),
    onScrollDown: () => changeWorkspace("-1"),

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
            .hook(Hyprland, removed, "workspace-removed")
            .hook(Hyprland, (self, name, data) => {
              if (name === "moveworkspace") moveWorkspace(self, data);
            }, "event");
        });
      },
    }),
  });
