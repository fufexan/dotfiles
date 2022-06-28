{pkgs, ...}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom = {
        start = "${pkgs.hyprland}/bin/hyprctl keyword decoration:blur 0";
        end = "${pkgs.hyprland}/bin/hyprctl keyword decoration:blur 1";
      };
    };
  };
}
