// Required components
import GLib from "gi://GLib";
import App from "resource:///com/github/Aylur/ags/app.js";
import Service from "resource:///com/github/Aylur/ags/service.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

// Services
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import PowerProfiles from "resource:///com/github/Aylur/ags/service/powerprofiles.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";

import Icons from "./utils/icons.js";

export {
  App,
  Audio,
  Battery,
  Bluetooth,
  GLib,
  Hyprland,
  Icons,
  Mpris,
  Network,
  Notifications,
  PowerProfiles,
  Service,
  SystemTray,
  Utils,
  Variable,
  Widget,
};
