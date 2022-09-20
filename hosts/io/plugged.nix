{
  pkgs,
  lib,
  inputs,
  ...
}: let
  programs = lib.makeBinPath [inputs.hyprland.packages.${pkgs.system}.default];
in {
  unplugged = pkgs.writeShellScript "unplugged" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)

    systemctl --user --machine=1000@ stop easyeffects syncthing
    hyprctl --batch 'keyword decoration:drop_shadow 0 ; keyword animations:enabled 0'
  '';

  plugged = pkgs.writeShellScript "plugged" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)

    systemctl --user --machine=1000@ start easyeffects syncthing
    hyprctl --batch 'keyword decoration:drop_shadow 1 ; keyword animations:enabled 1'
  '';
}
