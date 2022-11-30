{
  pkgs,
  config,
  colors,
  inputs,
  ...
}:
# graphical session configuration
# includes programs and services that work on both Wayland and X
{
  imports = [
    ../shell/nix.nix
    ./cinny.nix
    ./files
    ./media.nix
    ./spicetify.nix
    ./xdg.nix
  ];

  home.sessionVariables = {
    # enable scrolling in git diff
    DELTA_PAGER = "less -R";
  };

  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    libreoffice

    gh
    # messaging
    tdesktop
    (inputs.webcord.packages.${pkgs.system}.default.override {
      flags = let
        catppuccin = fetchFromGitHub {
          owner = "catppuccin";
          repo = "discord";
          rev = "159aac939d8c18da2e184c6581f5e13896e11697";
          sha256 = "sha256-cWpog52Ft4hqGh8sMWhiLUQp/XXipOPnSTG6LwUAGGA=";
        };

        theme = "${catppuccin}/themes/mocha.theme.css";
      in ["--add-css-theme=${theme}"];
    })
    inputs.self.packages.${pkgs.system}.discord-canary

    # let discord open links
    xdg-utils

    # school stuff
    inputs.nix-matlab.defaultPackage.${pkgs.system}
    inputs.nix-xilinx.packages.${pkgs.system}.vivado
    inputs.nix-xilinx.packages.${pkgs.system}.vitis_hls
    inputs.nix-xilinx.packages.${pkgs.system}.model_composer
    # torrents
    transmission-remote-gtk
    # misc
    libnotify
    obsidian
    timewarrior
    taskwarrior
    xournalpp
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Catppuccin-Orange-Dark-Compact";
      package = pkgs.catppuccin-gtk.override {size = "compact";};
    };
  };

  programs = {
    chromium = {
      enable = true;
      extensions = [{id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}];
    };

    firefox = {
      enable = true;
      profiles.mihai = {};
    };

    git = {
      enable = true;
      delta = {
        enable = true;
        options.map-styles = "bold purple => syntax #8839ef, bold cyan => syntax #1e66f5";
      };
      extraConfig = {
        diff.colorMoved = "default";
        merge.conflictstyle = "diff3";
      };
      aliases = {
        forgor = "commit --amend --no-edit";
        graph = "log --all --decorate --graph --oneline";
        oops = "checkout --";
      };
      ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
      signing = {
        key = "5899325F2F120900";
        signByDefault = true;
      };
      userEmail = "fufexan@protonmail.com";
      userName = "Mihai Fufezan";
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
      settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };

    zathura = let
      inherit (colors) xcolors;
    in {
      enable = true;
      options = {
        recolor = true;
        recolor-darkcolor = "#${xcolors.base00}";
        recolor-lightcolor = "rgba(0,0,0,0)";
        default-bg = "rgba(0,0,0,0.7)";
        default-fg = "#${xcolors.base06}";
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
      sshKeys = ["73D1C4271E8C508E1E55259660C94BE828B07738"];
    };

    syncthing.enable = true;
  };
}
