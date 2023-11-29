import { Network, Widget } from "../../../imports.js";

export const Net = Widget.Icon({
  className: "net module",

  binds: [
    [
      "icon",
      Network,
      "connectivity",
      (conn) => {
        if (conn == "none") return "";
        if (Network.primary == "wired") return "network-wired";

        return Network.wifi.icon_name;
      },
    ],
    [
      "tooltip-text",
      Network,
      "connectivity",
      (conn) => {
        if (conn == "none") return "";
        if (Network.primary == "wired") return "Wired";

        return Network.wifi.ssid;
      },
    ],
  ],
});
