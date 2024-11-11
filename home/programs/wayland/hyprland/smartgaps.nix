{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.wayland.windowManager.hyprland.settings.general) gaps_in gaps_out border_size;
  inherit (config.wayland.windowManager.hyprland.settings.decoration) rounding;
  inherit (builtins) concatStringsSep;
  inherit (lib.lists) flatten;

  workspaceSelectors = ["w[t1]" "w[tg1]" "f[1]"];

  toggleSmartGaps = let
    forEach = f: concatStringsSep "\n" (map f workspaceSelectors);
  in
    pkgs.writeShellScript "toggleSmartGaps" ''
      hyprctl -j workspacerules | ${lib.getExe pkgs.jaq} -e 'any(.[]; select(.workspaceString == "w[t1]" or .workspaceString == "w[tg1]" or .workspaceString == "w[f1]") | (.gapsIn | all(. == 0)) and (.gapsOut | all(. == 0)))' > /dev/null

      if [ $? -eq 0 ]; then
      ${forEach (selector: ''
        hyprctl keyword workspace "${selector}, gapsout:${toString gaps_out}, gapsin:${toString gaps_in}"
        hyprctl keyword windowrulev2 "bordersize ${toString border_size}, floating:0, onworkspace:${selector}"
        hyprctl keyword windowrulev2 "rounding ${toString rounding}, floating:0, onworkspace:${selector}"
      '')}
      else
      ${forEach (selector: ''
        hyprctl keyword workspace "${selector}, gapsout:0, gapsin:0"
        hyprctl keyword windowrulev2 "bordersize 0, floating:0, onworkspace:${selector}"
        hyprctl keyword windowrulev2 "rounding 0, floating:0, onworkspace:${selector}"
      '')}
      fi
    '';
in {
  # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
  # "Smart gaps" / "No gaps when only"
  wayland.windowManager.hyprland.settings = {
    workspace = map (x: "${x}, gapsout:0, gapsin:0") workspaceSelectors;

    windowrulev2 = flatten (map (x: [
        "bordersize 0, floating:0, onworkspace:${x}"
        "rounding 0, floating:0, onworkspace:${x}"
      ])
      workspaceSelectors);

    bind = [
      "$mod, M, exec, ${toggleSmartGaps}"
    ];
  };
}
