{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      packages = {
        # instant repl with automatic flake loading
        repl = pkgs.callPackage ./repl { };

        bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor { };

        stremio-linux-shell-rewrite-git = pkgs.callPackage ./stremio-linux-shell-rewrite-git { };
        wl-ocr = pkgs.callPackage ./wl-ocr { };
      };
    };
}
