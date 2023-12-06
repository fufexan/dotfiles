import { Variable, Widget } from "../../imports.js";
import { brightnessIndicator, volumeIndicator } from "./parts.js";

globalThis.osdVars = {
  reveal: Variable(false),
  debounceTimer: Date.now(),
  timePassed: 0,
  timeout: null,
};

const OsdContainer = Widget.Box({
  className: "osd-container",
  visible: false,
  children: [
    brightnessIndicator,
    volumeIndicator,
  ],
});

globalThis.osdcontainer = OsdContainer;

export const Osd = (monitor = 0) =>
  Widget.Window({
    monitor,
    name: `osd${monitor}`,
    layer: "overlay",
    visible: false,

    child: OsdContainer,
    binds: [["visible", osdVars.reveal]],
  });

export default Osd;
