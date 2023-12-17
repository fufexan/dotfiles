import { Network, Widget } from "../../../imports.js";

export default Widget.Icon({ className: "net module" })
  .bind(
    "icon",
    Network,
    "connectivity",
    (conn) => {
      if (conn == "none") return "";
      if (Network.primary == "wired") return "network-wired";

      return Network.wifi.icon_name;
    },
  )
  .bind(
    "tooltip-text",
    Network,
    "connectivity",
    (conn) => {
      if (conn == "none") return "";
      if (Network.primary == "wired") return "Wired";

      return Network.wifi.ssid;
    },
  );
