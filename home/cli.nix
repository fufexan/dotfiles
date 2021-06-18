{ config, pkgs, inputs, ... }:

# minimal config, suitable for servers

{
  imports = [
    # shell config
    ./modules/shell
  ];

  programs.home-manager.enable = true;
  home.username = "mihai";
  home.homeDirectory = "/home/mihai";
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    # archives
    p7zip
    unrar
    # file converters
    ffmpeg
    # file downloaders
    youtube-dl
    # file managers
    hunter
    ranger
    # nix tools
    nix-index
    nixpkgs-fmt
    inputs.nix-eval-lsp.defaultPackage.x86_64-linux
    # misc
    bat # better cat
    exa # ls alternative with colors & icons
    file # info about files
    gotop
    htop # system monitor
    ripgrep # better grep
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  xdg.enable = true;

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    stdlib = ''
      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };

  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };

  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" "result" ];
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

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    defaultCacheTtlSsh = 300;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
  };

  programs.skim = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    changeDirWidgetOptions = [
      "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
      "--exact"
    ];
  };

  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks =
      let
        home = config.home.homeDirectory;
      in
        {
          "homesv.local" = {
            user = "mihai";
            identityFile = "${home}/.ssh/id_ed25519";
          };
          "kiiro.local" = {
            user = "mihai";
            identityFile = "${home}/.ssh/id_ed25519";
          };
        };
  };
}
