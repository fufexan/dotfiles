import { App, Utils } from "./imports.js";
import Bar from "./windows/bar/main.js";
import { Osd } from "./windows/osd/main.js";

// start date of Ags, used for OSD
globalThis.startDate = Date.now();

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

Utils.exec(`sassc ${scss} ${css}`);

export default {
  style: css,
  windows: [Bar, Osd(0)],

  closeWindowDelay: {
    "osd": 500,
  },
};

function reloadCss() {
  console.log("scss change detected");
  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
}

Utils.monitorFile(`${App.configDir}/style`, reloadCss, "directory");
