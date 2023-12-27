import { Service, Utils } from "../imports.js";
import Gio from "gi://Gio";
import GLib from "gi://GLib";

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

  #interface = Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");
  #path = `/sys/class/backlight/${this.#interface}`;
  #brightness = `${this.#path}/brightness`;

  #max = Number(Utils.readFile(`${this.#path}/max_brightness`));

  get screen_value() {
    return this.#screenValue;
  }

  set screen_value(percent) {
    percent = clamp(percent, 0, 1);
    this.#screenValue = percent;

    const file = Gio.File.new_for_path(this.#brightness);
    const string = `${Math.round(percent * this.#max)}`;

    new Promise((resolve, _) => {
      file.replace_contents_bytes_async(
        new GLib.Bytes(new TextEncoder().encode(string)),
        null,
        false,
        Gio.FileCreateFlags.NONE,
        null,
        (self, res) => {
          try {
            self.replace_contents_finish(res);
            resolve(self);
          } catch (error) {
            print(error);
          }
        },
      );
    });
  }

  constructor() {
    super();

    this.#updateScreenValue();
    Utils.monitorFile(this.#brightness, () => this.#onChange());
  }

  #updateScreenValue() {
    this.#screenValue = Number(Utils.readFile(this.#brightness)) / this.#max;
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

export default service;
