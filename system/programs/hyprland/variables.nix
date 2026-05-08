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

    gaps_in = 4
    gaps_out = 8

    mod = "SUPER"

    text_color = "rgb(b6c4ff)"
    border_active_color = "rgba(35447988)"
    border_inactive_color = "rgba(dce1ff88)"

    screencopy_perms = {"${config.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped", "${lib.getExe pkgs.grim}", "${lib.getExe pkgs.wl-screenrec}"}
  '';
}
