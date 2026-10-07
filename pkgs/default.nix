{ inputs, self, ... }:
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

        # dark.jpg + light.jpg: brightness/contrast-adjusted variants of one
        # source. -modulate is brightness,saturation,hue (%); -resize scales down
        # (no crop, preserving aspect) so hyprpaper's `cover` fits each monitor.
        wallpapers =
          let
            wallpaperSrc = pkgs.fetchurl {
              name = "wallpaper-source.jpg";
              url = "https://images.unsplash.com/photo-1673368777914-a3bdac42c5e0?ixlib=rb-4.1.0&q=100&fm=jpg&cs=srgb&dl=rafael-garcin-L7sDY9KL9G8-unsplash.jpg";
              hash = "sha256-K6ksD7ylUzuHGk7MxdcLUSkM5PAx0Qm/R8yLWyDs8c8=";
            };
          in
          pkgs.runCommand "wallpapers" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
            mkdir -p $out
            magick ${wallpaperSrc} -modulate 65 -resize 2560x -strip $out/dark.jpg
            magick ${wallpaperSrc} -modulate 128 -brightness-contrast 0x-8 -resize 2560x -strip $out/light.jpg
          '';

        bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor { };

        stremio-linux-shell = pkgs.callPackage ./stremio-linux-shell {
          src = inputs.stremio;
          version = pkgs.lib.removePrefix "v" (pkgs.lib.importJSON "${self}/.tack/pins.lock.json")
          .stremio.tag;
        };
        wl-ocr = pkgs.callPackage ./wl-ocr { };
      };
    };
}
