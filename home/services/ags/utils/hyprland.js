import { Hyprland, Utils } from "../imports.js";

export const dispatch = (ws) =>
  Utils.execAsync(["hyprctl", "dispatch", "workspace", `${ws}`]);

export const focusedSwitch = (self) => {
  const id = Hyprland.active.workspace.id;
  if (self.lastFocused == id) return;

  self.children[self.lastFocused - 1].toggleClassName("focused", false);
  self.children[id - 1].toggleClassName("focused", true);
  self.lastFocused = id;
};

export const added = (self, name) => {
  if (!name) return;
  const id = Number(name);
  const monitor = Hyprland.getWorkspace(id).monitorID;

  const child = self.children[id - 1];
  child.monitor = monitor;
  child.active = true;
  child.toggleClassName(`monitor${monitor}`);

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
  child.active = false;
  child.toggleClassName(`monitor${child.monitor}`, false);

  // if this id is the biggest id, unvisibilise it and all other inactives until the next active before it
  if (id == self.biggestId) {
    makeInvisible(self, id);
  }
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
