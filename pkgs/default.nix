{
  systems = ["x86_64-linux"];

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      # instant repl with automatic flake loading
      repl = pkgs.callPackage ./repl {};

      bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor {};

      wl-ocr = pkgs.callPackage ./wl-ocr {};
    };
  };
}
