{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf_v1

      # bitmap fonts
      gohufont
      tewi-font

      # nerdfonts
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Japanese input using fcitx
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

  programs.dconf.enable = true;

  services = {
    geoclue2.enable = true;

    ipfs = {
      enable = true;
      autoMount = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    udisks2.enable = true;

    xserver = {
      enable = true;

      displayManager.autoLogin = {
        enable = true;
        user = "mihai";
      };
      displayManager.sddm.enable = true;

      windowManager.bspwm.enable = true;

      libinput = {
        enable = true;
        # disable mouse acceleration
        mouse.accelProfile = "flat";
        mouse.accelSpeed = "0";
        mouse.middleEmulation = false;
      };
    };
  };
}
