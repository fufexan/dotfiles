{ config, pkgs, inputs, ... }:

# graphical session configuration
# includes programs and services that work on both Wayland and X

{
  imports = [
    ./cli.nix # base config
  ];

  # install programs
  home.packages = with pkgs; [
    # messaging
    discord
    element-desktop
    tdesktop
    # torrents
    transmission-remote-gtk
    # misc
    libnotify
  ];

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Orchis-dark-compact";
      package = pkgs.orchis;
    };
  };

  # programs
  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_padding = true;
      window.padding = {
        x = 5;
        y = 5;
      };
      scrolling.history = 10000;
      font =
        let
          font = "JetBrainsMono Nerd Font";
        in
        {
          normal.family = font;
          bold.family = font;
          italic.family = font;
          size = 11.0;
        };
      draw_bold_text_with_bright_colors = true;
      colors = {
        primary = {
          background = "0x16161c";
          foreground = "0xfdf0ed";
        };
        normal = {
          black = "0x232530";
          red = "0xe95678";
          green = "0x29d398";
          yellow = "0xfab795";
          blue = "0x26bbd9";
          magenta = "0xee64ae";
          cyan = "0x59e3e3";
          white = "0xfadad1";
        };
        bright = {
          black = "0x2e303e";
          red = "0xec6a88";
          green = "0x3fdaa4";
          yellow = "0xfbc3a7";
          blue = "0x3fc6de";
          magenta = "0xf075b7";
          cyan = "0x6be6e6";
          white = "0xfdf0ed";
        };
      };
      background_opacity = 0.7;
      live_config_reload = true;
    };
  };

  programs.firefox = {
    enable = true;
    profiles.mihai.name = "mihai";
  };

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    settings = {
      scrollback_lines = 10000;
      window_padding_width = 4;

      allow_remote_control = "yes";

      # colors
      background_opacity = "0.7";
      foreground = "#fdf0ed";
      background = "#16161c";
      # black
      color0 = "#232530";
      color8 = "#2e303e";
      # red
      color1 = "#e95678";
      color9 = "#ec6a88";
      # green
      color2 = "#29d398";
      color10 = "#3fdaa4";
      # yellow
      color3 = "#fab795";
      color11 = "#fbc3a7";
      # blue
      color4 = "#26bbd9";
      color12 = "#3fc6de";
      # magenta
      color5 = "#ee64ae";
      color13 = "#f075b7";
      # cyan
      color6 = "#59e3e3";
      color14 = "#6be6e6";
      # white
      color7 = "#fadad1";
      color15 = "#fdf0ed";
    };
  };

  programs.newsboat = {
    enable = false;
    autoReload = true;
    urls = [
      {
        title = "Drew DeVault's Blog";
        url = "https://drewdevault.com/blog/index.xml";
      }
      {
        title = "Christine Dodrill's Blog";
        url = "https://christine.website/blog.rss";
      }
    ];
  };

  programs.texlive = {
    enable = false;
    package = pkgs.texlive.combined.scheme-basic;
  };

  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-darkcolor = "#FDF0ED";
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";
      default-fg = "#FDF0ED";
    };
  };

  # services
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 300;
      defaultCacheTtlSsh = 300;
      pinentryFlavor = "gnome3";
    };

    syncthing.enable = true;

    udiskie.enable = true;
  };

  xresources.properties = {
    #! special
    "*.foreground" = "#fdf0ed";
    "*.background" = "#16161c";
    "*.cursorColor" = "#D8DEE9";
    "*fading" = 35;
    "*fadeColor" = "#4C566A";

    #! black
    "*.color0" = "#232530";
    "*.color8" = "#2e303e";

    #! red
    "*.color1" = "#e95678";
    "*.color9" = "#ec6a88";

    #! green
    "*.color2" = "#29d398";
    "*.color10" = "#3fdaa4";

    #! yellow
    "*.color3" = "#fab795";
    "*.color11" = "#fbc3a7";

    #! blue
    "*.color4" = "#26bbd9";
    "*.color12" = "#3fc6de";

    #! magenta
    "*.color5" = "#ee64ae";
    "*.color13" = "#f075b7";

    #! cyan
    "*.color6" = "#59e3e3";
    "*.color14" = "#6be6e6";

    #! white
    "*.color7" = "#fadad1";
    "*.color15" = "#fdf0ed";
  };
}
