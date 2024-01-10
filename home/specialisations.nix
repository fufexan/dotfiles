{
  pkgs,
  # default,
  lib,
  ...
}: {
  # light/dark specialisations
  specialisation = let
    colorschemePath = "/org/gnome/desktop/interface/color-scheme";
    dconf = "${pkgs.dconf}/bin/dconf";

    dconfDark = lib.hm.dag.entryAfter ["dconfSettings"] ''
      ${dconf} write ${colorschemePath} "'prefer-dark'"
    '';
    dconfLight = lib.hm.dag.entryAfter ["dconfSettings"] ''
      ${dconf} write ${colorschemePath} "'prefer-light'"
    '';
  in {
    light.configuration = {
      programs.matugen.variant = "light";
      home.activation = {inherit dconfLight;};
    };
    dark.configuration = {
      programs.matugen.variant = "dark";
      home.activation = {inherit dconfDark;};
    };
  };

  # programs.matugen = {
  #   enable = false;
  #   wallpaper = default.wallpaper;
  # };
}
