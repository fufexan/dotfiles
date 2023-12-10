import { osdVars, Widget } from "../../imports.js";
import { brightnessIndicator, volumeIndicator } from "./parts.js";

const OsdContainer = Widget.Box({
  className: "osd-container",
  visible: false,
  children: [
    brightnessIndicator,
    volumeIndicator,
  ],
});

osdVars.value.osdcontainer = OsdContainer;

export const Osd = (monitor = 0) =>
  Widget.Window({
    monitor,
    name: `osd${monitor}`,
    layer: "overlay",
    visible: false,

    child: OsdContainer,
    binds: [["visible", osdVars.value.reveal]],
  });

export default Osd;
