{ config, pkgs, inputs, ... }:

# minimal config, suitable for servers

{
  imports = [
    # shell config
    ./shell
  ];

  programs.home-manager.enable = true;
  home = {
    username = "mihai";
    homeDirectory = "/home/mihai";
    stateVersion = "20.09";
  };

  home.packages = with pkgs; [
    # archives
    p7zip
    unrar

    # file downloaders
    youtube-dl

    # file managers
    xplr

    # coreutils
    bat # better cat
    bottom # system monitor
    exa # ls alternative with colors & icons
    fd # better find
    file # info about files
    ripgrep # better grep
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  xdg.enable = true;

  programs = {
    gh = {
      enable = true;
      gitProtocol = "ssh";
    };

    git = {
      enable = true;
      ignores = [ "*~" "*.swp" "result" ];
      signing = {
        key = "3AC82B48170331D3";
        signByDefault = true;
      };
      userEmail = "fufexan@pm.me";
      userName = "Mihai Fufezan";
    };

    gpg = {
      enable = true;
      settings = { homedir = "~/.local/share/gnupg"; };
    };
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
      settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
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

    ssh.enable = true;
  };
}
