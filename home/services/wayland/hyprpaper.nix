{
  pkgs,
  inputs,
  config,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;

    importantPrefixes = [ "monitor" ];

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "${config.theme.wallpaper.dark}";
          fit_mode = "cover";
        }
      ];
    };
  };

  # darkman -> hyprpaper: swap to the mode's wallpaper variant live
  services.darkman.scripts.wallpaper =
    let
      hyprctl = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/hyprctl";
    in
    ''
      if [ "$1" = "light" ]; then
        wp="${config.theme.wallpaper.light}"
      else
        wp="${config.theme.wallpaper.dark}"
      fi
      ${hyprctl} hyprpaper preload "$wp" || true
      ${hyprctl} hyprpaper wallpaper ", $wp" || true
    '';
}
