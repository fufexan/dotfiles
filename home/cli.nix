{pkgs, ...}:
# minimal config, suitable for servers
{
  imports = [./shell/zsh.nix];

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

    joshuto
  ];
  home.extraOutputsToInstall = ["doc" "info" "devdoc"];

  programs.home-manager.enable = true;

  programs.ssh.enable = true;
}
