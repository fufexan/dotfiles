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
          path = config.theme.wallpaper;
          fit_mode = "cover";
        }
      ];
    };
  };
}
