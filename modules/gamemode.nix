{
  pkgs,
  inputs,
  ...
}: let
  startscript = pkgs.writeShellScript "gamemode-start" ''
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls /tmp/hypr | sort | tail -n 1)
    ${inputs.self.packages.${pkgs.system}.hyprland}/bin/hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:no_vfr 1'
    ${pkgs.systemd}/bin/systemctl --user stop easyeffects
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls /tmp/hypr | sort | tail -n 1)
    ${inputs.self.packages.${pkgs.system}.hyprland}/bin/hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:no_vfr 0'
    ${pkgs.systemd}/bin/systemctl --user start easyeffects
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
