{pkgs, ...}:
# manage files in ~
{
  imports = [
    ./wlogout.nix
    ./wofi-style.nix
  ];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  xdg.configFile = {
    "btop/themes/catppuccin_mocha.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/7109eac2884e9ca1dae431c0d7b8bc2a7ce54e54/themes/catppuccin_mocha.theme";
      hash = "sha256-KnXUnp2sAolP7XOpNhX2g8m26josrqfTycPIBifS90Y=";
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
