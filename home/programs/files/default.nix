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

  xdg.configFile."xilinx/nix.sh" = {
    executable = true;
    text = ''
      INSTALL_DIR=$HOME/Documents/code/xilinx/tools/Xilinx
      VERSION=2022.2
    '';
  };
}
