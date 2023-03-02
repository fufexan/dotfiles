{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # office
    libreoffice

    # messaging
    tdesktop
    inputs.self.packages.${pkgs.hostPlatform.system}.discord-canary
    (inputs.webcord.packages.${pkgs.hostPlatform.system}.default.override {
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
    # let discord open links
    xdg-utils

    # school stuff
    inputs.nix-matlab.defaultPackage.${pkgs.hostPlatform.system}
    inputs.nix-xilinx.packages.${pkgs.hostPlatform.system}.model_composer
    inputs.nix-xilinx.packages.${pkgs.hostPlatform.system}.vitis_hls
    inputs.nix-xilinx.packages.${pkgs.hostPlatform.system}.vivado
    jetbrains.idea-community

    # torrents
    transmission-remote-gtk

    # misc
    libnotify

    # productivity
    obsidian
    taskwarrior
    timewarrior
    xournalpp
  ];
}
