{ config }:

let
  wm = "wayfire";
  wayland-session = ''
    systemctl --user import-environment
    systemctl --user start hm-graphical-session.target
    
  '' + /*
    gnome_schema=org.gnome.desktop.interface

    gsettings set $gnome_schema gtk-theme ${config.gtk.theme.name}
    gsettings set $gnome_schema icon-theme ${config.gtk.iconTheme.name}
    gsettings set $gnome_schema cursor-theme ${config.xsession.pointerCursor.name}
    gsettings set $gnome_schema font-name ${config.gtk.font.name}
  */''
    
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
