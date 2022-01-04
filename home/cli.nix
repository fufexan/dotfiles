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
    # modern coreutils
    bat
    bottom
    du-dust
    duf
    exa
    fd
    ripgrep
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  programs.ssh.enable = true;
}
