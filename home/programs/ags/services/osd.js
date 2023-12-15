import { Audio, Icons, Service, Utils } from "../imports.js";
import { audioIcon, micIcon } from "../utils/audio.js";
import Brightness from "./brightness.js";

class Indicator extends Service {
  static {
    Service.register(this, {
      "popup": ["jsobject", "boolean"],
    });
  }

  #delay = 1500;
  #count = 0;

  popup(value, label, icon, showProgress = true) {
    const props = {
      value,
      label,
      icon,
      showProgress,
    };
    this.emit("popup", props, true);
    this.#count++;
    Utils.timeout(this.#delay, () => {
      this.#count--;

      if (this.#count === 0) {
        this.emit("popup", props, false);
      }
    });
  }

  bluetooth(addr) {
    this.popup(
      0,
      getBluetoothDevice(addr),
      Icons.bluetooth.active,
      false,
    );
  }

  speaker() {
    this.popup(
      Audio.speaker?.volume ?? 0,
      Audio.speaker?.description ?? "",
      audioIcon(),
    );
  }

  mic() {
    this.popup(
      Audio.microphone?.volume || 0,
      Audio.microphone?.description || "",
      micIcon(),
    );
  }

  display() {
    // brightness is async, so lets wait a bit
    Utils.timeout(10, () =>
      this.popup(
        Brightness.screenValue,
        "Brightness",
        Icons.brightness,
      ));
  }

  connect(event = "popup", callback) {
    return super.connect(event, callback);
  }
}

export default new Indicator();
