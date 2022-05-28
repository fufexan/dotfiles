{
  config,
  pkgs,
  lib,
  ...
}: {
  fonts = {
    fonts = with pkgs; [
      # icon fonts
      material-icons
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto

      # nerdfonts
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment.systemPackages = with pkgs; [
    glib
    gsettings-desktop-schemas
    quintom-cursor-theme
  ];

  # Japanese input using fcitx
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [mozc];
  };

  location.provider = "geoclue2";

  networking = {
    firewall = {
      # for Rocket League
      allowedTCPPortRanges = [
        {
          from = 27015;
          to = 27030;
        }
        {
          from = 27036;
          to = 27037;
        }
      ];
      allowedUDPPorts = [4380 27036 34197];
      allowedUDPPortRanges = [
        {
          from = 7000;
          to = 9000;
        }
        {
          from = 27000;
          to = 27031;
        }
      ];

      # Spotify downloaded track sync with other devices
      allowedTCPPorts = [57621];
    };
  };

  # add gaming cache
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  programs.dconf.enable = true;

  services = {
    dbus.packages = [pkgs.gcr];

    geoclue2.enable = true;

    kmonad.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    udisks2.enable = true;

    upower.enable = true;

    xserver = {
      enable = true;

      displayManager.gdm.enable = true;

      displayManager.session = [
        {
          manage = "window";
          name = "home-manager";
          start = "exec $HOME/.xsession-hm";
        }
        {
          manage = "window";
          name = "Sway";
          start = "exec sway";
        }
      ];

      libinput = {
        enable = true;
        # disable mouse acceleration
        mouse.accelProfile = "flat";
        mouse.accelSpeed = "0";
        mouse.middleEmulation = false;
        # touchpad settings
        touchpad.naturalScrolling = true;
      };
    };

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  xdg.portal = let
    gnome = config.services.xserver.desktopManager.gnome.enable;
  in {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "eDP-1";
          max_fps = 60;
          exec_before = "pkill mako";
          exec_after = "mako";
          chooser_type = "default";
        };
      };
    };
    extraPortals =
      [pkgs.xdg-desktop-portal-wlr]
      ++ lib.optional (!gnome) pkgs.xdg-desktop-portal-gtk;
    gtkUsePortal = !gnome;
  };
}
