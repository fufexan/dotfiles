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

    settings = {
      preload = [ "${config.theme.wallpaper}" ];
      wallpaper = [ ", ${config.theme.wallpaper}" ];
    };
  };
}
