let
  wm = "wayfire";

  wayland-session = ''
    systemctl --user import-environment
    #systemctl --user start hm-graphical-session.target

    dbus-run-session ${wm}

    systemctl --user stop graphical-session.target
    systemctl --user stop graphical-session-pre.target

    # Wait until the units actually stop.
    while [ -n "$(systemctl --user --no-legend --state=deactivating list-units)" ]; do
      sleep 0.5
    done
  '';
in
  wayland-session
