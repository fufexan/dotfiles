{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [./config.nix];

  home.packages = with pkgs; [
    jaq
    xorg.xprop
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  home.sessionVariables = {
    # upscale steam
    GDK_SCALE = "2";
  };

  # start swayidle as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  # enable hyprland
  wayland.windowManager.hyprland.enable = true;
}
