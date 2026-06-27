#!/usr/bin/env python3

import dbus
import dbus.mainloop.glib
import json
import re
import subprocess
from gi.repository import GLib

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

bus = dbus.SessionBus()
obj = bus.get_object("com.ddcutil.DdcutilService", "/com/ddcutil/DdcutilObject")
iface = dbus.Interface(obj, "com.ddcutil.DdcutilInterface")

DISPLAY_NUM = 1
CONNECTOR = "HDMI-A-1"
OTHER_INPUT = "0x12"
POLL_INTERVAL_MS = 300
ERROR_THRESHOLD = 3

last_state = None
consecutive_errors = 0
display_awake = True
prog = re.compile("0x[0-9]{2}")


def redetect():
    print("Re-running display detection...")
    try:
        iface.Detect(0)
    except Exception as e:
        print(f"Detect error: {e}")


def hyprland_check_connected(connector):
    completed_process = subprocess.run(
        ["hyprctl", "monitors", "all", "-j"], capture_output=True
    )
    monitors = json.loads(completed_process.stdout)
    return any(x["name"] == connector for x in monitors)


def hyprland_monitor(enable: bool):
    cmd_enable = (
        "mode = 'preferred', position = 'auto', scale = 'auto', disabled = false"
    )
    cmd_disable = "disabled = true"
    subprocess.run(
        [
            "hyprctl",
            "eval",
            "hl.monitor({ output = "
            + f'"{CONNECTOR}", '
            + (cmd_enable if enable else cmd_disable)
            + " })",
        ]
    )
    print(f"{'En' if enable else 'Dis'}abled {CONNECTOR}")


def poll_input():
    global last_state, consecutive_errors
    try:
        result = iface.GetVcp(DISPLAY_NUM, "", dbus.Byte(0x60), dbus.UInt32(0))
        current_value = prog.search(result[2]).group(0)
        is_ours = str(current_value) != OTHER_INPUT
        consecutive_errors = 0

        if is_ours != last_state and hyprland_check_connected(CONNECTOR):
            last_state = is_ours
            hyprland_monitor(is_ours)

    except Exception as e:
        print(f"Poll error: {e}")
        consecutive_errors += 1
        if consecutive_errors >= ERROR_THRESHOLD:
            redetect()
            consecutive_errors = 0
            # if still in hyprland, it's connected to us — enable it
            if hyprland_check_connected(CONNECTOR) and last_state != True:
                last_state = True
                hyprland_monitor(True)

    return True


def on_connected_displays_changed(edid, event_type, flags):
    global display_awake, last_state
    event_type = int(event_type)

    if event_type == 0:  # DPMS asleep
        print("Display entered standby")
        display_awake = False
    elif event_type == 1:  # DPMS awake
        print("Display woke up, polling immediately...")
        display_awake = True
        last_state = None  # force re-apply in case input changed while asleep
        poll_input()
    elif event_type == 2:
        print("Display connected")
    elif event_type == 3:
        print("Display disconnected")


bus.add_signal_receiver(
    on_connected_displays_changed,
    signal_name="ConnectedDisplaysChanged",
    dbus_interface="com.ddcutil.DdcutilInterface",
    path="/com/ddcutil/DdcutilObject",
)

poll_input()
GLib.timeout_add(POLL_INTERVAL_MS, poll_input)
print(f"Polling display {DISPLAY_NUM} input every {POLL_INTERVAL_MS}ms...")
GLib.MainLoop().run()
