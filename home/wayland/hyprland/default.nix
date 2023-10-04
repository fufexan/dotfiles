{
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

  # start swayidle as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix];
  };
}
