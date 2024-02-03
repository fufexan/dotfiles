{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # layer rules
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      ignorealpha = [
        # ags
        "calendar"
        "notifications"
        "osd"
        "system-menu"

        "anyrun"
      ];

      layers = ignorealpha ++ ["bar" "gtk-layer-shell"];
    in [
      "blur, ${toRegex layers}"
      "xray 1, ${toRegex ["bar" "gtk-layer-shell"]}"
      "ignorealpha 0.2, ${toRegex ["bar" "gtk-layer-shell"]}"
      "ignorealpha 0.5, ${toRegex (ignorealpha ++ ["music"])}"
    ];

    # window rules
    windowrulev2 = [
      # telegram media viewer
      "float, title:^(Media viewer)$"

      # allow tearing in games
      "immediate, class:^(osu\!|cs2)$"

      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # start spotify in ws9
      "workspace 9 silent, title:^(Spotify( Premium)?)$"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # fix xwayland apps
      "rounding 0, xwayland:1"
      "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
    ];
  };
}
