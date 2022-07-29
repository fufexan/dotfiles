{pkgs, ...}: let
  startscript = pkgs.writeShellScript "gamemode-start" ''
    hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; misc:no_vfr 1'
    dunstctl set-paused true
    systemctl --user stop easyeffects
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; misc:no_vfr 0'
    dunstctl set-paused false
    systemctl --user start easyeffects
  '';
in {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom = {
        start = "${startscript}";
        end = "${endscript}";
      };
    };
  };
}
