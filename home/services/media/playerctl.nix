{pkgs, ...}: {
  home.packages = [pkgs.playerctl];

  services.playerctld.enable = true;
}
