{ config, pkgs, inputs, ... }:

# minimal config, suitable for servers

{
  imports = [
    # shell config
    ./modules/shell
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
    # file converters
    ffmpeg
    # file downloaders
    youtube-dl
    # file managers
    xplr
    # nix tools
    nix-index
    nixpkgs-fmt
    inputs.rnix-lsp.defaultPackage.x86_64-linux
    inputs.nix-eval-lsp.defaultPackage.x86_64-linux
    # misc
    bat # better cat
    bottom # system monitor
    exa # ls alternative with colors & icons
    fd # better find
    file # info about files
    gotop
    ripgrep # better grep
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  xdg.enable = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
      enableZshIntegration = true;
    };

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

    ssh = {
      enable = true;
      matchBlocks =
        let
          home = config.home.homeDirectory;
        in
        {
          "homesv" = {
            host = "100.84.134.107";
            identityFile = "${home}/.ssh/id_ed25519";
          };
          "kiiro" = {
            host = "100.79.149.35";
            identityFile = "${home}/.ssh/id_ed25519";
          };
          "phone" = {
            host = "100.124.95.67";
          };
        };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    defaultCacheTtlSsh = 300;
  };
}
