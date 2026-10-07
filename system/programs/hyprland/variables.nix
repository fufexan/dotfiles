{
  config,
  pkgs,
  lib,
  ...
}:
{

  environment.etc."xdg/hypr/variables.lua".text = ''
    cursorName = "Bibata-Modern-Classic-Hyprcursor"
    cursorSize = "16"

    rounding = 10
    rounding_power = 2.5

    gaps_in = 4
    gaps_out = 8

    mod = "SUPER"

    dark_active_border = "rgba(88888888)"
    dark_inactive_border = "rgba(00000088)"
    dark_text_color = "rgb(000000)"
    dark_text_color_inactive = "rgba(ffffff66)"
    dark_group_active_color = "rgba(ffffff66)"
    dark_group_inactive_color = "rgba(00000066)"

    light_active_border="rgb(000000)"
    light_inactive_border="rgba(00000000)"
    light_text_color="rgb(ffffff)"
    light_text_color_inactive="rgba(00000066)"
    light_group_active="rgba(00000066)"
    light_group_inactive="rgba(ffffff66)"

    screencopy_perms = {"${config.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped", "${lib.getExe pkgs.grim}", "${lib.getExe pkgs.wl-screenrec}"}
  '';
}
