{ configs, pkgs, ... }:

{
  # install packages specific to X
  environment.systemPackages = with pkgs; [
    # gui utils
    feh maim polybarFull rofi rofi-emoji picom

    # notifications
    dunst

    # cli utils
    xclip xorg.xkill xdotool

    # also install sxhkd for bspwm
    sxhkd
  ];

  # keyboard configuration
  # configures with Colemak mods that you specify
  nixpkgs.config.packageOverrides = super: rec {
    xorg = super.xorg // rec {
      xkeyboardconfig_colemak_mods = super.xorg.xkeyboardconfig.overrideAttrs (old: rec {
        kbdTricks = pkgs.fetchFromGitHub {
          owner = "fufexan";
          repo = "BigBagKbdTrixXKB";
          rev = "872b1891fd3d8b43e1e0fee6a1a0ef6ccda99e49";
          sha256 = "0dk2yf88wxqs3vjif1w2p16a0zvhqkp84h3gr29wq67ggvlxgq4r";
        };

        postFixup = ''
          bash ${kbdTricks}/install-dreymar-xmod.sh -nsoc $out/etc/X11 5caw ro us
        '';
      });

      xorgserver = super.xorg.xorgserver.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [
          "--with-xkb-bin-directory=${xkbcomp}/bin"
          "--with-xkb-path=${xkeyboardconfig_colemak_mods}/share/X11/xkb"
        ];
      });

      setxkbmap = super.xorg.setxkbmap.overrideAttrs (old: {
        postInstall =
          ''
            mkdir -p $out/share
            ln -sfn ${xkeyboardconfig_colemak_mods}/etc/X11 $out/share/X11
          '';
      });

      xkbcomp = super.xorg.xkbcomp.overrideAttrs (old: {
        configureFlags = "--with-xkb-config-root=${xkeyboardconfig_colemak_mods}/share/X11/xkb";
      });

    }; # xorg

    xkbvalidate = super.xkbvalidate.override {
      libxkbcommon = super.libxkbcommon.override {
        xkeyboard_config = xorg.xkeyboardconfig_colemak_mods;
      };
    };
  }; # packageOverrides

  # configure X
  services.xserver = {
    enable = true;

    # keyboard config
    layout = "ro";
    xkbModel = "pc105aw-sl";
    xkbOptions = "caps:escape,misc:cmk_curl_dh";
    xkbVariant = "cmk_ed_ks";

    videoDrivers = [ "nvidia" ];

    # display manager setup
    displayManager = {
      defaultSession = "none+bspwm";
    };

    windowManager.bspwm.enable = true;

    # disable mouse acceleration
    libinput = {
      enable = true;
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };
}
