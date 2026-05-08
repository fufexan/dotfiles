{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.hyprland.nixosModules.default

    ./variables.nix
  ];

  environment.systemPackages = [
    inputs.hyprland-contrib.packages.${system}.grimblast
    inputs.self.packages.${system}.bibata-hyprcursor
  ];

  environment.pathsToLink = [ "/share/icons" ];

  # enable hyprland and required options
  programs.hyprland = {
    enable = true;
    withUWSM = true;

    plugins = with inputs.hyprland-plugins.packages.${system}; [
      # hyprbars
      # hyprexpo
    ];
  };

  # tell Electron/Chromium to run on Wayland
  environment.variables.NIXOS_OZONE_WL = "1";

  # write the Lua config
  environment.etc =
    let
      lua = [
        ./animations.lua
        ./binds.lua
        ./hyprland.lua
        ./rules.lua
        ./settings.lua
        ./smartgaps.lua
      ];
    in
    builtins.listToAttrs (
      map (e: {
        name = "xdg/hypr/${lib.baseNameOf e}";
        value = {
          source = e;
        };
      }) lua
    );
}
