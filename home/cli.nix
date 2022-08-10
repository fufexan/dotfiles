{pkgs, ...}:
# cli utilities
{
  imports = [./shell/zsh.nix];

  home = {
    username = "mihai";
    homeDirectory = "/home/mihai";
    stateVersion = "20.09";
  };

  home.packages = with pkgs; [
    file
    du-dust
    duf
    fd
    ripgrep

    joshuto
    ranger
  ];
  home.extraOutputsToInstall = ["doc" "devdoc"];

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "ansi";
      };
    };

    bottom.enable = true;
    exa.enable = true;
    home-manager.enable = true;
    ssh.enable = true;
  };
}
