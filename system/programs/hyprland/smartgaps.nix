{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.programs.hyprland.settings.general) gaps_in gaps_out border_size;
  inherit (config.programs.hyprland.settings.decoration) rounding;
  inherit (builtins) concatStringsSep;
  inherit (lib.lists) flatten;

  workspaceSelectors = [
    "w[t1]"
    "w[tg1]"
    "f[1]"
  ];

  toggleSmartGaps =
    let
      forEach = f: concatStringsSep "\n" (map f workspaceSelectors);
    in
    pkgs.writeShellScript "toggleSmartGaps" ''
      hyprctl -j workspacerules | ${lib.getExe pkgs.jaq} -e 'any(.[]; select(.workspaceString == "w[t1]" or .workspaceString == "w[tg1]" or .workspaceString == "w[f1]") | (.gapsIn | all(. == 0)) and (.gapsOut | all(. == 0)))' > /dev/null

      if [ $? -eq 0 ]; then
      ${forEach (selector: ''
        hyprctl keyword workspace "${selector}, gapsout:${toString gaps_out}, gapsin:${toString gaps_in}"
        hyprctl keyword windowrule "border_size ${toString border_size}, match:float false, match:workspace ${selector}"
        hyprctl keyword windowrule "rounding ${toString rounding}, match:float false, match:workspace ${selector}"
      '')}
      else
      ${forEach (selector: ''
        hyprctl keyword workspace "${selector}, gapsout:0, gapsin:0"
        hyprctl keyword windowrule "border_size 0, match:float false, match:workspace ${selector}"
        hyprctl keyword windowrule "rounding 0, match:float false, match:workspace ${selector}"
      '')}
      fi
    '';
in
{
  # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
  # "Smart gaps" / "No gaps when only"
  programs.hyprland.settings = {
    workspace = map (x: "${x}, gapsout:0, gapsin:0") workspaceSelectors;

    windowrule = flatten (
      map (x: [
        "border_size 0, match:float false, match:workspace ${x}"
        "rounding 0, match:float false, match:workspace ${x}"
      ]) workspaceSelectors
    );

    bind = [
      "$mod, M, exec, ${toggleSmartGaps}"
    ];
  };
}
