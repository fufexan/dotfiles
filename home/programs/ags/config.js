import { App, Utils } from "./imports.js";
import Bar from "./windows/bar/main.js";
import Music from "./windows/music/main.js";
import Osd from "./windows/osd/main.js";
import SystemMenu from "./windows/system-menu/main.js";

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

Utils.exec(`sassc ${scss} ${css}`);

export default {
  style: css,
  windows: [
    Bar,
    Music,
    Osd(0),
    SystemMenu,
  ],
};

function reloadCss() {
  console.log("scss change detected");
  Utils.exec(`sassc ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
}

Utils.monitorFile(`${App.configDir}/style`, reloadCss, "directory");
