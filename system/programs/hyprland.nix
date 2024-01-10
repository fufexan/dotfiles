{inputs, ...}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  # enable hyprland and required options
  programs.hyprland.enable = true;
}
