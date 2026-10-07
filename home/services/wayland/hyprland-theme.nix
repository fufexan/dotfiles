{
  pkgs,
  inputs,
  ...
}:
let
  hyprctl = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/hyprctl";
in
{
  services.darkman.scripts.hyprland = ''
    if [ "$1" != "light" ] && [ "$1" != "dark" ]; then
      echo "argument must be 'dark' or 'light'"
      exit 1
    fi

    ${hyprctl} eval "hl.config({
      general = { col = { active_border = ''${1}_active_border, inactive_border = ''${1}_inactive_border } },
      group = {
        col = { border_active = ''${1}active_border, border_inactive = ''${1}inactive_border },
        groupbar = {
          text_color = ''${1}text_color,
          text_color_inactive = ''${1}text_color_inactive,
          col = { active = ''${1}group_active, inactive = ''${1}group_inactive },
        },
      },
    })"
  '';
}
