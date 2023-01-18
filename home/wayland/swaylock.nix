{default, ...}: {
  programs.swaylock.settings = let
    inherit (default) xcolors;
  in {
    clock = true;
    effect-blur = "30x3";
    font = "Roboto";
    ignore-empty-password = true;
    image = default.wallpaper;
    indicator = true;
    bs-hl-color = xcolors.red;
    key-hl-color = xcolors.peach;
    inside-clear-color = xcolors.red;
    inside-color = xcolors.yellow;
    inside-ver-color = xcolors.blue;
    inside-wrong-color = xcolors.red;
    line-color = xcolors.crust;
    ring-color = xcolors.base;
    separator-color = xcolors.subtext1;
  };
}
