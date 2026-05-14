{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./theme/filetype.nix
    ./theme/icons.nix
    ./theme/manager.nix
    ./theme/status.nix
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
        layout = [
          1
          4
          3
        ];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = config.xdg.cacheHome;
      };
    };

    theme = {
      flavor.dark = "base16";
      flavor.light = "base16";
    };

    # Run ripdrag when pressing C-n
    keymap.manager.prepend_keymap = [
      {
        on = [ "<C-n>" ];
        run = ''shell '${lib.getExe pkgs.ripdrag} "$@" -x 2>/dev/null &' --confirm'';
      }
    ];
  };
}
