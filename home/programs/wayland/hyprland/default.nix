{
  inputs,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  cursor = "Bibata-Modern-Classic-Hyprcursor";
  cursorPackage = inputs.self.packages.${system}.bibata-hyprcursor;
in
{
  imports = [
    ./binds.nix
    ./rules.nix
    ./settings.nix
    ./smartgaps.nix
  ];

  home.packages = [
    inputs.hyprland-contrib.packages.${system}.grimblast
  ];

  xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${system}.default;

    plugins = with inputs.hyprland-plugins.packages.${system}; [
      # hyprbars
      # hyprexpo
    ];

    systemd = {
      enable = false;
      variables = [ "--all" ];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
