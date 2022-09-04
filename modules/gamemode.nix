{
  pkgs,
  inputs,
  lib,
  ...
}: let
  programs = lib.makeBinPath (with pkgs; [
    inputs.hyprland.packages.${pkgs.system}.default
    systemd
  ]);

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:no_vfr 1'

    status=$(systemctl --user --machine=1000@ is-active easyeffects)
    if [[ $status == "active" ]]; then
      systemctl --user stop easyeffects
      echo "start" > /tmp/gamemodestate
    else
      echo "stop" > /tmp/gamemodestate
    fi
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:no_vfr 0'

    action=$(cat /tmp/gamemodestate)
    systemctl --user $action easyeffects
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
