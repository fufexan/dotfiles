{
  config,
  pkgs,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = let
      c = config.programs.matugen.theme.colors.colors.${config.theme.name};
    in {
      clock = true;
      font = "Inter";
      image = config.theme.wallpaper;
      indicator = true;

      bs-hl-color = c.error;
      key-hl-color = c.tertiary;
      separator-color = c.on_primary;
      text-color = c.on_primary;

      inside-color = c.primary;
      line-color = c.primary;
      ring-color = c.on_primary;

      inside-clear-color = c.secondary;
      line-clear-color = c.secondary;
      ring-clear-color = c.on_primary;

      inside-ver-color = c.primary;
      line-ver-color = c.primary;
      ring-ver-color = c.on_primary;

      inside-wrong-color = c.error;
      line-wrong-color = c.error;
      ring-wrong-color = c.on_primary;
    };
  };
}
