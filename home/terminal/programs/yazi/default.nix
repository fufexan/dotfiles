{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./theme/icons.nix
  ];

  # general file info
  home.packages = [ pkgs.exiftool ];

  xdg.configFile."yazi/flavors/base16.yazi".source = pkgs.fetchFromGitHub {
    owner = "matt-dong-123";
    repo = "base16.yazi";
    rev = "ed793528890e2b37595c76b70c212ccfdc81d9ae";
    hash = "sha256-1WhixzYE1zsXg9o6T/YKWJgzfRZnzsmpiUIfi+j4H9Q=";
  };

  # yazi file manager
  programs.yazi = {
    enable = true;

    package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
      flavor.dark = "base16";
      flavor.light = "base16";
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
