{
  config,
  pkgs,
  inputs,
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

  # use Wayland where possible (electron)
  environment.variables.NIXOS_OZONE_WL = "1";

  # enable location service
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

      # Spotify track sync with other devices
      allowedTCPPorts = [57621];
    };
  };

  nix.settings = {
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # make HM-managed GTK stuff work
  programs.dconf.enable = true;

  services = {
    # provide location
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    # keyboard remapping
    kmonad = {
      enable = true;
      package = inputs.kmonad.packages.${pkgs.system}.default;
      keyboards = {
        one2mini = {
          device = "/dev/input/by-id/usb-Ducky_Ducky_One2_Mini_RGB_DK-V1.17-190813-event-kbd";
          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = false;
          };
          config = builtins.readFile "${inputs.self}/modules/main.kbd";
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    # battery info & stuff
    upower.enable = true;

    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [pkgs.gcr];
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.swaylock.text = "auth include login";

    # userland niceness
    rtkit.enable = true;
  };

  xdg.portal.enable = true;
  # wlroots screensharing
  xdg.portal.wlr = {
    enable = true;
    settings.screencast = {
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };
}
