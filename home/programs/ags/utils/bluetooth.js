import { Bluetooth } from "../imports.js";

export const getBluetoothDevice = (addr) =>
  Bluetooth.getDevice(addr).alias ?? Bluetooth.getDevice(addr).name;
