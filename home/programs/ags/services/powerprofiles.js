import { Service } from "../imports.js";
import Gio from "gi://Gio";

const NAME = "net.hadess.PowerProfiles";

const icon = (name) => `power-profile-${name}-symbolic`;

class PowerProfiles extends Service {
  static {
    Service.register(this, {}, {
      "actions": ["string", "r"],
      "active-profile": ["string", "rw"],
      "active-profile-holds": ["jsobject", "r"],
      "performance-degraded": ["string", "r"],
      "profiles": ["jsobject", "r"],
      "icon": ["string", "r"],
    });
  }

  #proxy;

  #getProxy() {
    const xmlFile = Gio.File.new_for_path(`services/${NAME}.xml`);
    const [_, contents] = xmlFile.load_contents(null);
    const decoder = new TextDecoder("utf-8");
    const interfaceXml = decoder.decode(contents);

    const Proxy = Gio.DBusProxy.makeProxyWrapper(interfaceXml);

    return new Proxy(
      Gio.DBus.system,
      NAME,
      "/net/hadess/PowerProfiles",
    );
  }

  constructor() {
    super();

    this.#proxy = this.#getProxy();
  }

  get actions() {
    return this.#proxy.Actions;
  }

  get profiles() {
    return this.#proxy.Profiles.map((p) => {
      return {
        profile: p.Profile.unpack(),
        driver: p.Driver.unpack(),
        icon: icon(p.Profile.unpack()),
      };
    });
  }

  get activeProfile() {
    return this.#proxy.ActiveProfile;
  }

  set activeProfile(profile) {
    this.#proxy.ActiveProfile = profile;
    this.notify("icon");
    this.notify("active-profile");
  }

  get activeProfileHolds() {
    return this.#proxy.ActiveProfileHolds;
  }

  get performanceDegraded() {
    return this.#proxy.PerformanceDegraded;
  }

  get icon() {
    return icon(this.#proxy.ActiveProfile);
  }
}

const service = new PowerProfiles();
globalThis.powerprofiles = service;

export default service;
