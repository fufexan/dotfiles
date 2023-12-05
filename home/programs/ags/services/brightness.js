import { Service, Utils } from "../imports.js";
const { exec, readFile, writeFile, monitorFile } = Utils;

const clamp = (num, min, max) => Math.min(Math.max(num, min), max);

class BrightnessService extends Service {
  static {
    Service.register(
      this,
      { "screen-changed": ["float"] },
      { "screen-value": ["float", "rw"] },
    );
  }

  #screenValue = 0;

  #interface = exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");
  #path = `/sys/class/backlight/${this.#interface}`;
  #brightness = `${this.#path}/brightness`;

  #max = Number(readFile(`${this.#path}/max_brightness`));

  get screen_value() {
    return this.#screenValue;
  }

  set screen_value(percent) {
    percent = clamp(percent, 0, 1);
    this.#screenValue = percent;

    writeFile(percent * this.#max, this.#brightness)
      .then(() => {
        // signals has to be explicity emitted
        this.emit("screen-changed", percent);
        this.notify("screen-value");

        // or use Service.changed(propName: string) which does the above two
        // this.changed("screen");
      })
      .catch(print);
  }

  constructor() {
    super();

    this.#updateScreenValue();
    monitorFile(this.#brightness, () => this.#onChange());
  }

  #updateScreenValue() {
    this.#screenValue = Number(readFile(this.#brightness)) / this.#max;
  }

  #onChange() {
    this.#updateScreenValue();

    this.notify("screen-value");
    this.emit("screen-changed", this.#screenValue);
  }

  connectWidget(widget, callback, event = "screen-changed") {
    super.connectWidget(widget, callback, event);
  }
}

const service = new BrightnessService();

// make it global for easy use with cli
globalThis.brightness = service;

export default service;
