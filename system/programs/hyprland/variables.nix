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

    active_border = "rgba(88888888)"
    inactive_border = "rgba(00000088)"
    text_color = "rgb(000000)"
    text_color_inactive = "rgba(ffffff66)"
    group_active_color = "rgba(ffffff66)"
    group_inactive_color = "rgba(00000066)"

    screencopy_perms = {"${config.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped", "${lib.getExe pkgs.grim}", "${lib.getExe pkgs.wl-screenrec}"}
  '';
}
