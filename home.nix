{ config, pkgs, lib, ... }:

{
  imports = [
    # files to link in ~
    ./modules/files.nix
    # shell management
    ./modules/shell-environment.nix
    # X config
    ./modules/xsession.nix
  ];

  # let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "mihai";
  home.homeDirectory = "/home/mihai";
  home.stateVersion = "20.09";

  # install user packages 
  home.packages = with pkgs; [
    # archives
    p7zip
    unrar
    # audio
    audacity
    carla
    pavucontrol
    playerctl
    pulsemixer
    # documents
    #libreoffice
    # file converters
    ffmpeg
    # file downloaders
    youtube-dl
    # file managers
    ranger
    # games
    lutris
    # messaging
    discord
    element-desktop
    mumble
    tdesktop
    zoom-us
    # music
    spotify
    # nix tools
    nix-index
    # torrents
    transmission-remote-gtk
    # video
    droidcam
    jellyfin-mpv-shim
    vlc
    # misc
    discord-rpc # RPC interfacing lib
    dunst # for dunstctl
    freerdp # for MS Office
    piper # configure mouse
    scrcpy # mirror Android screen
    htop # system monitor
    gotop
    exa # ls alternative with colors & icons
    file # info about files
    glxinfo # info about OpenGL
    usbutils
    ueberzug # image display in terminals
    xdragon # file drag n drop
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  # accounts
  #accounts.email = {
  #  accounts.fufexan = {
  #    address = "mihai@fufexan.xyz";
  #    aliases = [ "me@fufexan.xyz" ];
  #    name = "mihai";
  #    neomutt.enable = true;
  #    notmuch.enable = true;
  #    offlineimap.enable = true;
  #  };
  #};

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
      window.dynamic_padding = false;
      window.padding = {
        x = 0;
        y = 0;
      };
      scrolling.history = 10000;
      font = {
        normal.family = "FiraCode Nerd Font";
        bold.family = "FiraCode Nerd Font";
        italic.family = "FiraCode Nerd Font";
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
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs27;
  };
  programs.feh.enable = true;
  programs.firefox = {
    enable = true;
    profiles.mihai.name = "mihai";
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    changeDirWidgetOptions =
      [ "--preview 'tree -C -L 3 -a {} | head -200'" "--exact" ];
  };
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    signing = {
      key = "3AC82B48170331D3";
      signByDefault = true;
    };
    userEmail = "fufexan@pm.me";
    userName = "Mihai Fufezan";
  };
  programs.gpg = {
    enable = true;
    settings = { homedir = "~/.local/share/gnupg"; };
  };
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = { ncmpcpp_directory = "~/.local/share/ncmpcpp"; };
  };
  programs.neomutt = {
    enable = false;
    checkStatsInterval = 60;
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      coc-nvim
      coc-pairs
      coc-prettier
      coc-snippets
      coc-highlight
      latex-live-preview
      vimsence
    ];
    extraConfig = builtins.readFile ./config/init.vim;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
    pass = {
      enable = true;
      extraConfig = ''
        URL_field='url';
        USERNAME_field='user';
        AUTOTYPE_field='autotype';
      '';
      stores = [ "$HOME/.local/share/password-store" ];
    };
    theme = ./config/rofi/general.rasi;
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
  services.caffeine.enable = true;
  services.flameshot.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    defaultCacheTtlSsh = 300;
  };
  services.lorri.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      zeroconf_enabled "yes"
      zeroconf_name "MPD @ %h"
      input {
        plugin "curl"
      }
      audio_output {
        type "fifo"
        name "Visualizer"
        path "/tmp/mpd.fifo"
        format    "48000:16:2"
      }
      audio_output {
        type "pulse"
        name "PulseAudio"
      }
    '';
    network.listenAddress = "any";
    network.startWhenNeeded = true;
  };
  services.mpdris2.enable = true;
  services.playerctld.enable = true;
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      pulseSupport = true;
    };
    config = ./config/polybar;
    script = ''
      polybar main &
      polybar external &
    '';
  };
  services.random-background = {
    enable = true;
    imageDirectory =
      "${config.home.homeDirectory}/Pictures/wallpapers/artworks";
  };
  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };
  services.syncthing.enable = true;
  services.udiskie.enable = true;
  #services.xcape = {
  #  enable = true;
  #  mapExpression = { Caps_Lock = "Escape"; };
  #  timeout = 100;
  #};

  xdg.enable = true;
}
