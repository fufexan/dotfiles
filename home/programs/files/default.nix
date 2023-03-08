{
  pkgs,
  lib,
  config,
  ...
}:
# manage files in ~
{
  imports = [
    ./nix-index-update-db.nix
    ./wlogout.nix
    ./wofi-style.nix
  ];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  xdg.configFile = {
    "btop/themes/catppuccin_mocha.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/main/catppuccin_mocha.theme";
      hash = "sha256-MGK5ECB5sXiHdi2A3Y4s/Sx7nSRQ+KLyZjEKElRPKf0=";
    };

    "xilinx/nix.sh" = {
      executable = true;
      text = ''
        INSTALL_DIR=$HOME/Documents/code/xilinx/tools/Xilinx
        VERSION=2022.2
      '';
    };
  };
}
