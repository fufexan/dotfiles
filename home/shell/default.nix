{config, ...}: let
  h = config.home.homeDirectory;
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
    ./cli.nix
    ./nix.nix
    ./zsh.nix
  ];

  # add locations to $PATH
  home.sessionPath = [
    (h + "/.local/bin")
    (h + "/.local/bin/rofi")
  ];

  # add environment variables
  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = cache + "/less/history";
    LESSKEY = c + "/less/lesskey";
    WINEPREFIX = d + "/wine";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    EDITOR = "hx";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  xdg = {
    enable = true;
    cacheHome = __toPath (h + "/.local/cache");
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
