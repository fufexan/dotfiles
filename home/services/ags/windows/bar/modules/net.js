import { Network, Widget } from "../../../imports.js";
import { getNetIcon, getNetText } from "../../../utils/net.js";

export default () =>
  Widget.Icon({ className: "net module" })
    .bind(
      "icon",
      Network,
      "connectivity",
      getNetIcon,
    )
    .bind(
      "tooltip-text",
      Network,
      "connectivity",
      getNetText,
    );
