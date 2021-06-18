{ pkgs, ... }:

# copyright gvolpe, licensed under Apache License 2.0
# https://github.com/gvolpe/nix-config/blob/8a34b4e793ccc46b0659f80b290eb33bbce640c4/home/services/polybar/scripts/mpris.nix

let
  pctl = "${pkgs.playerctl}/bin/playerctl";
in
pkgs.writeShellScriptBin "mpris" ''
  echo $(${pctl} --player=playerctld,%any metadata --format '{{ artist }} - {{ title }}')
''
