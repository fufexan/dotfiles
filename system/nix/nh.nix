{ lib, ... }:
{
  programs.nh = {
    enable = true;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d";
    };
  };

  environment.variables.NH_FLAKE = lib.mkDefault "/home/mihai/Projects/dotfiles";
}
