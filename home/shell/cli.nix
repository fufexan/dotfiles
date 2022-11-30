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
        theme = "Catppuccin-mocha";
      };
      themes = {
        Catppuccin-mocha = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "00bd462e8fab5f74490335dcf881ebe7784d23fa";
            sha256 = "yzn+1IXxQaKcCK7fBdjtVohns0kbN+gcqbWVE4Bx7G8=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
    };
    bottom.enable = true;
    exa.enable = true;
    ssh.enable = true;
  };
}
