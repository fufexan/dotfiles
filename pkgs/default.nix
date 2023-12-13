{default, ...}: {
  systems = ["x86_64-linux"];

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      # instant repl with automatic flake loading
      repl = pkgs.callPackage ./repl {};

      catppuccin-plymouth = pkgs.callPackage ./catppuccin-plymouth {};

      overskride = pkgs.callPackage ./overskride {};

      theme = pkgs.callPackage ./theme-generator {
        matugen = inputs'.matugen.packages.default;
        wallpaper = default.wallpaper;
      };
    };
  };
}
