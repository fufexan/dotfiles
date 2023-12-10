export const resource = (file) => `resource:///com/github/Aylur/ags/${file}.js`;
export const require = async (file) => (await import(resource(file))).default;
export const requireCustom = async (path) => (await import(path)).default;
export const service = async (file) => await require(`service/${file}`);

export const App = await require("app");
export const GLib = await requireCustom("gi://GLib");
export const Gtk = await requireCustom("gi://Gtk?version=3.0");
export const Service = await require("service");
export const Utils = await import(resource("utils"));
export const Variable = await require("variable");
export const Widget = await require("widget");

// Services
export const Audio = await service("audio");
export const Battery = await service("battery");
export const Bluetooth = await service("bluetooth");
export const Hyprland = await service("hyprland");
export const Mpris = await service("mpris");
export const Network = await service("network");

// My definitions
export const Icons = await requireCustom("./icons.js");

// Variables
export const startDate = Date.now();
export const osdVars = Variable({
  reveal: Variable(false),
  debounceTimer: Date.now(),
  timePassed: 0,
  timeout: null,
  container: null,
});

export const musicVisible = Variable(false);
