self: pkgs: let
  inherit (pkgs) lib;
  colors = builtins.fromJSON (builtins.readFile self.packages.${pkgs.system}.theme.outPath);
  colorlib = import "${self}/lib/theme/colorlib.nix" lib;
in {
  inherit colors;
  # #RRGGBB
  xcolors = lib.mapAttrsRecursive (_: colorlib.x) colors;
  # rgba(,,,) colors (css)
  rgbaColors = lib.mapAttrsRecursive (_: colorlib.rgba) colors;

  variant = "dark";
}
