{ lib, ... }:
{
  programs.hyprland.settings = {
    # layer rules
    layerrule =
      let
        toRegex =
          list:
          let
            elements = lib.concatStringsSep "|" list;
          in
          "match:namespace ^(${elements})$";

        lowopacity = [
          "bar"
          "calendar"
          "notifications"
          "system-menu"
          "quickshell:bar"
          "quickshell:notifications:overlay"
          "quickshell:osd"
        ];

        highopacity = [
          "anyrun"
          "osd"
          "logout_dialog"
          "quickshell:sidebar"
        ];

        blurred = lib.concatLists [
          lowopacity
          highopacity
        ];
      in
      [
        "${toRegex blurred}, blur true"
        "match:namespace ^quickshell.*$, blur_popups true"
        "${
          toRegex [
            "bar"
            "quickshell:bar"
          ]
        }, xray true"
        "${toRegex (highopacity ++ [ "music" ])}, ignore_alpha 0.5"
        "${toRegex lowopacity}, ignore_alpha 0.2"
        "${
          toRegex [
            "notifications"
            "quickshell:notifications:overlay"
            "quickshell:notifictaions:panel"
          ]
        }, no_anim true"
      ];

    # window rules
    windowrule = [
      # telegram media viewer
      "match:title ^(Media viewer)$, float on"

      # Bitwarden extension
      "match:title ^(.*Bitwarden Password Manager.*)$, float on"

      # gnome calculator
      "match:class ^(org.gnome.Calculator)$, float on"
      "match:class ^(org.gnome.Calculator)$, size 360 490"

      # allow tearing in games
      "match:class ^(osu\!|cs2)$, immediate on"

      # make Firefox/Zen PiP window float oning and sticky
      "match:title ^(Picture-in-Picture)$, float on"
      "match:title ^(Picture-in-Picture)$, pin on"

      # throw sharing indicators away
      "match:title ^(Firefox — Sharing Indicator)$, workspace special silent"
      "match:title ^(Zen — Sharing Indicator)$, workspace special silent"
      "match:title ^(.*is sharing (your screen|a window)\.)$, workspace special silent"

      # start Spotify and YouTube Music in ws9
      "match:title ^(Spotify( Premium)?)$, workspace 9 silent"
      "match:title ^(YouTube Music)$, workspace 9 silent"

      # idle inhibit while watching videos
      "match:class ^(mpv|.+exe|celluloid)$, idle_inhibit focus"
      "match:class ^(zen)$, match:title ^(.*YouTube.*)$, idle_inhibit focus"
      "match:class ^(zen)$, idle_inhibit fullscreen"

      "match:class ^(gcr-prompter)$, dim_around on"
      "match:class ^(xdg-desktop-portal-gtk)$, dim_around on"
      "match:class ^(polkit-gnome-authentication-agent-1)$, dim_around on"
      "match:class ^(zen)$, match:title ^(File Upload)$, dim_around on"

      # fix xwayland apps
      "match:xwayland true, rounding 0"
      "match:class ^(.*jetbrains.*)$, match:title ^(Confirm Exit|Open Project|win424|win201|splash)$, center on"
      "match:class ^(.*jetbrains.*)$, match:title ^(splash)$, size 640 400"

      # Matlab
      "match:title MATLAB, tile on"
      "match:class MATLAB, match:title DefaultOverlayManager.JWindow, no_anim on"
      "match:class MATLAB, match:title DefaultOverlayManager.JWindow, no_blur on"
      "match:class MATLAB, match:title DefaultOverlayManager.JWindow, border_size 0"
      "match:class MATLAB, match:title DefaultOverlayManager.JWindow, no_shadow on"
      # NOTE: does not work
      "match:class MATLAB, match:title DefaultOverlayManager.JWindow, hyprbars:no_bar on"

      # don't render hyprbars on tiling windows
      "match:float true, hyprbars:no_bar on"

      # less sensitive scroll for some windows
      # browser(-based)
      "match:class ^(zen|firefox|chromium-browser|chrome-.*)$, scroll_touchpad 0.1"
      "match:class ^(obsidian)$, scroll_touchpad 0.1"
      "match:class ^(steam)$, scroll_touchpad 0.1"
      "match:class ^(Zotero)$, scroll_touchpad 0.1"
      # GTK3
      "match:class ^(com.github.xournalpp.xournalpp)$, scroll_touchpad 0.1"
      "match:class ^(libreoffice.*)$, scroll_touchpad 0.1"
      "match:class ^(.virt-manager-wrapped)$, scroll_touchpad 0.1"
      "match:class ^(xdg-desktop-portal-gtk)$, scroll_touchpad 0.1"
      # Qt5
      "match:class ^(org.prismlauncher.PrismLauncher)$, scroll_touchpad 0.1"
      "match:class ^(org.kde.kdeconnect.app)$, scroll_touchpad 0.1"
      # Others
      "match:class ^(org.pwmt.zathura)$, scroll_touchpad 0.1"
    ];
  };
}
