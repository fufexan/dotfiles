{ pkgs, ... }:
{
  programs = {
    gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };

    steam = {
      enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];

      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };
  };
}
