{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./theme/icons.nix
  ];

  # general file info
  home.packages = [ pkgs.exiftool ];

  xdg.configFile."yazi/flavors".source = pkgs.fetchFromGitHub {
    owner = "fufexan";
    repo = "base16.yazi";
    rev = "c9929919b8c02b7a53d10470d45b847ff565dc7a";
    hash = "sha256-GspH8eiAdPkpaL1HeDMTZPCDN23X96tuKD7Hf6AZukI=";
  };

  # yazi file manager
  programs.yazi = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    shellWrapperName = "y";

    settings = {
      manager = {
        sort_by = "natural";
        sort_translit = true;
        linemode = "size_and_mtime";
        show_hidden = false;
        show_symlink = true;
      };
    };

    theme = {
      flavor.dark = "base16-dark";
      flavor.light = "base16-light";
    };

    # Run ripdrag when pressing C-n
    keymap.mgr.prepend_keymap =
      let
        ripdrag = "shell -- ${lib.getExe pkgs.ripdrag} %s -ax 2>/dev/null &";
      in
      [
        {
          on = "<C-n>";
          run = ripdrag;
        }
        {
          on = [
            "c"
            "r"
          ];
          run = ripdrag;
          desc = "Drag & drop";
        }
      ];
  };
}
