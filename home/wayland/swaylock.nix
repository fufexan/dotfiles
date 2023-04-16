{
  default,
  pkgs,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = let
      inherit (default) xcolors;
    in {
      clock = true;
      font = "Jost *";
      image = default.wallpaper;
      indicator = true;

      bs-hl-color = xcolors.red;
      key-hl-color = xcolors.text;
      separator-color = xcolors.base;
      text-color = xcolors.base;

      inside-color = xcolors.mauve;
      line-color = xcolors.mauve;
      ring-color = xcolors.base;

      inside-clear-color = xcolors.yellow;
      line-clear-color = xcolors.yellow;
      ring-clear-color = xcolors.base;

      inside-ver-color = xcolors.lavender;
      line-ver-color = xcolors.lavender;
      ring-ver-color = xcolors.base;

      inside-wrong-color = xcolors.red;
      line-wrong-color = xcolors.red;
      ring-wrong-color = xcolors.base;
    };
  };
}
