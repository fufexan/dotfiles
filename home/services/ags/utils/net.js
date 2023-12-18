import { Network } from "../imports.js";

export const getNetIcon = (conn) => {
  if (conn == "none") return "";
  if (Network.primary == "wired") return "network-wired";

  return Network.wifi.icon_name;
};

export const getNetText = (conn) => {
  if (conn == "none") return "";
  if (Network.primary == "wired") return "Wired";

  return Network.wifi.ssid;
};
