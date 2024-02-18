import { Hyprland } from "../imports.js";

export let DEFAULT_MONITOR;
const connID = Hyprland.connect("notify::workspaces", () => {
  Hyprland.disconnect(connID);

  DEFAULT_MONITOR = {
    name: Hyprland.monitors[0].name,
    id: Hyprland.monitors[0].id,
  };
});

export const changeWorkspace = (ws) => Hyprland.messageAsync(`dispatch workspace ${ws}`);

export const focusedSwitch = (self) => {
  const id = Hyprland.active.workspace.id;
  if (self.lastFocused == id) return;

  self.children[self.lastFocused - 1].toggleClassName("focused", false);
  self.children[id - 1].toggleClassName("focused", true);
  self.lastFocused = id;
};

export const added = (self, name) => {
  if (!name) return;
  const ws = Hyprland.workspaces.find((e) => e.name == name);
  const id = ws?.id ?? Number(name);
  const child = self.children[id - 1];

  child.monitor = {
    name: ws?.monitor ?? DEFAULT_MONITOR.name,
    id: ws?.monitorID ?? DEFAULT_MONITOR.id,
  };

  child.active = true;
  child.toggleClassName(`monitor${child.monitor.id}`, true);

  // if this id is bigger than the last biggest id, visibilise all other ws before it
  if (id > self.biggestId) {
    for (let i = self.biggestId; i <= id; i++) {
      self.children[i - 1].visible = true;
    }
    self.biggestId = id;
  }
};

const makeInvisible = (self, id) => {
  if (id <= 1) return;

  const child = self.children[id - 1];
  if (child.active) {
    self.biggestId = id;
    return;
  }

  child.visible = false;
  makeInvisible(self, id - 1);
};

export const removed = (self, name) => {
  if (!name) return;

  const id = Number(name);
  const child = self.children[id - 1];

  child.toggleClassName(`monitor${child.monitor.id}`, false);
  child.active = false;

  // if this id is the biggest id, unvisibilise it and all other inactives until the next active before it
  if (id == self.biggestId) {
    makeInvisible(self, id);
  }
};

export const moveWorkspace = (self, data) => {
  const [id, name] = data.split(",");

  const child = self.children[id - 1];

  // remove previous monitor class
  child.toggleClassName(`monitor${child.monitor.id}`, false);

  // add new monitor and class
  const monitor = Hyprland.monitors.find((e) => e.name == name);

  child.monitor = {
    name,
    id: monitor?.id ?? DEFAULT_MONITOR.id,
  };

  print(`child ${id}: monitor ${name} ${child.monitor.id}`);
  child.toggleClassName(`monitor${child.monitor.id}`, true);
};

export const sortWorkspaces = () => {
  return Hyprland.workspaces
    .sort((x, y) => {
      return x.id - y.id;
    })
    .filter((x) => {
      return x.name.indexOf("special") == -1;
    });
};

export const getLastWorkspaceId = () => sortWorkspaces().slice(-1)[0].id;
export const workspaceActive = (id) => sortWorkspaces().some((e) => e.id == id);
