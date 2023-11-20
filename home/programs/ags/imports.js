export const resource = (file) => `resource:///com/github/Aylur/ags/${file}.js`;
export const require = async (file) => (await import(resource(file))).default;
export const service = async (file) => await require(`service/${file}`);

export const App = await require("app");
export const Widget = await require("widget");
export const Utils = await import(resource("utils"));
export const Battery = await service("battery");
export const Bluetooth = await service("bluetooth");
export const Network = await service("network");
