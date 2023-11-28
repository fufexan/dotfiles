import { App, Utils } from "./imports.js";
import Bar from "./windows/bar/main.js";

const scss = App.configDir + "/style.scss";
const css = App.configDir + "/style.css";

Utils.exec(`sassc ${scss} ${css}`);

export default {
  style: css,
  windows: [Bar],
};

Utils.subprocess(
  [
    "inotifywait",
    "--recursive",
    "--event",
    "create,modify",
    "-m",
    App.configDir + "/style",
  ],
  () => {
    print("scss change detected");
    Utils.exec(`sassc ${scss} ${css}`);
    App.resetCss();
    App.applyCss(css);
  },
);
