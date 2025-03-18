{config, ...}: let
  # pointer = config.home.pointerCursor;
  cursorName = "Bibata-Modern-Classic-Hyprcursor";
in {
  programs.hyprland.settings = {
    "$mod" = "SUPER";
    env = [
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "HYPRCURSOR_THEME,${cursorName}"
      "HYPRCURSOR_SIZE,${toString 16}"
    ];

    exec-once = [
      # finalize startup
      "uwsm finalize"
      # set cursor for HL itself
      "hyprctl setcursor ${cursorName} ${toString 16}"
      "hyprlock"
    ];

    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 1;
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";

      allow_tearing = true;
      resize_on_border = true;
    };

    decoration = {
      rounding = 10;
      rounding_power = 3;
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.01;

        vibrancy = 0.2;
        vibrancy_darkness = 0.5;

        passes = 4;
        size = 7;

        popups = true;
        popups_ignorealpha = 0.2;
      };

      shadow = {
        enabled = true;
        color = "rgba(00000055)";
        ignore_window = true;
        offset = "0 15";
        range = 100;
        render_power = 2;
        scale = 0.97;
      };
    };

    animations.enabled = true;

    animation = [
      "border, 1, 2, default"
      "fade, 1, 4, default"
      "windows, 1, 3, default, popin 80%"
      "workspaces, 1, 2, default, slide"
    ];

    group = {
      groupbar = {
        font_size = 10;
        gradients = false;
        text_color = "rgb(b6c4ff)";
      };

      "col.border_active" = "rgba(35447988)";
      "col.border_inactive" = "rgba(dce1ff88)";
    };

    input = {
      kb_layout = "ro";

      # focus change on cursor move
      follow_mouse = 1;
      accel_profile = "flat";
      tablet.output = "current";
    };

    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      force_default_wallpaper = 0;

      # disable dragging animation
      animate_mouse_windowdragging = false;

      # enable variable refresh rate (effective depending on hardware)
      vrr = 1;
    };

    render.direct_scanout = true;

    # touchpad gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };

    xwayland.force_zero_scaling = true;

    debug.disable_logs = false;

    # plugin = {
    #   csgo-vulkan-fix = {
    #     res_w = 1280;
    #     res_h = 800;
    #     class = "cs2";
    #   };

    #   hyprbars = {
    #     bar_height = 20;
    #     bar_precedence_over_border = true;

    #     # order is right-to-left
    #     hyprbars-button = [
    #       # close
    #       "rgb(ffb4ab), 15, , hyprctl dispatch killactive"
    #       # maximize
    #       "rgb(b6c4ff), 15, , hyprctl dispatch fullscreen 1"
    #     ];
    #   };

    #   hyprexpo = {
    #     columns = 3;
    #     gap_size = 4;
    #     bg_col = "rgb(000000)";

    #     enable_gesture = true;
    #     gesture_distance = 300;
    #     gesture_positive = false;
    #   };
    # };
  };
}
