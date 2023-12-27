import { Bluetooth, Widget } from "../../../imports.js";
import {
  getBluetoothIcon,
  getBluetoothText,
} from "../../../utils/bluetooth.js";

export default () =>
  Widget.Icon({ className: "bluetooth module" })
    .bind("icon", Bluetooth, "connected-devices", getBluetoothIcon)
    .bind("tooltip-text", Bluetooth, "connected-devices", getBluetoothText);
