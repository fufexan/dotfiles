import { Network } from "../imports.js";

export const getNetIcon = () => {
  if (Network.connectivity == "none") return "";
  if (Network.primary == "wired") return "network-wired-symbolic";

  return Network.wifi.icon_name;
};

export const getNetText = () => {
  // no connection
  if (Network.connectivity == "none") return "No connection";

  // wired
  if (Network.primary == "wired") return "Wired";

  // wifi
  const wifi = Network.wifi;
  switch (wifi.internet) {
    case "connected":
      return wifi.ssid;
    case "connecting":
      return "Connecting";
    case "disconnected":
      return "Disconnected";
  }
};
