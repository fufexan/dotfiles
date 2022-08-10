{pkgs, ...}:
# cli utilities
{

  home.packages = with pkgs; [
    file
    du-dust
    duf
    fd
    ripgrep

    joshuto
    ranger
  ];

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
    ssh.enable = true;
  };
}
