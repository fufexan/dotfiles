{ config, pkgs, ... }:

# graphical session configuration
# includes programs and services that work on both Wayland and X

{
  imports = [
    ./minimal.nix # base config
    ./editors/emacs.nix
    ./modules/files.nix # files to link in ~
    ./modules/mail.nix
    ./modules/media.nix # audio/video
    ./modules/wayland.nix
    ./modules/xsession.nix
  ];

  # install programs
  home.packages = with pkgs; [
    # games
    lutris
    # messaging
    discord
    element-desktop
    mumble
    tdesktop
    zoom-us
    # torrents
    transmission-remote-gtk
    # video
    droidcam
    # misc
    cached-nix-shell
    discord-rpc # RPC interfacing lib
    freerdp # for MS Office
    piper # configure mouse
    scrcpy # mirror Android screen
    ueberzug # image display in terminals
  ];

  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    theme.name = "Orchis-dark-compact";
    theme.package = pkgs.orchis;
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
      font = let font = "JetBrainsMono Nerd Font";
      in {
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
    package = pkgs.firefox-bin;
    profiles.mihai.name = "mihai";
  };

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    settings = {
      scrollback_lines = 10000;
      window_padding_width = 4;

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

  programs.neovim.plugins = with pkgs.vimPlugins; [
    coc-prettier
    coc-snippets
    latex-live-preview
  ];

  programs.newsboat = {
    enable = true;
    autoReload = true;
    urls = [{
      title = "Drew DeVault's Blog";
      url = "https://drewdevault.com/blog/index.xml";
    }];
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
  services.syncthing.enable = true;

  services.udiskie.enable = true;
}
