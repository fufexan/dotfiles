import { App, Utils } from "./imports.js";
import Bar from "./windows/bar/main.js";
import Music from "./windows/music/main.js";
import Osd from "./windows/osd/main.js";
import SystemMenu from "./windows/system-menu/main.js";

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

Utils.exec(`sass ${scss} ${css}`);

export default {
  style: css,
  windows: [
    SystemMenu,
    Music,
    Osd,
    Bar,
  ],

  closeWindowDelay: {
    "system-menu": 200,
  },
};

function reloadCss() {
  console.log("scss change detected");
  Utils.exec(`sass ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
}

Utils.monitorFile(`${App.configDir}/style`, reloadCss, "directory");
