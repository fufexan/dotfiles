inputs: _: prev: rec {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  technic-launcher = prev.callPackage ./technic.nix {};

  tlauncher = prev.callPackage ./tlauncher.nix {};

  waveform = prev.callPackage ./waveform {};

  sway-hidpi = import ./sway-hidpi.nix prev;

  spotifywm = prev.spotifywm.overrideAttrs (old: {
    version = "2022-09-21-unstable";
    src = prev.fetchFromGitHub {
      owner = "amurzeau";
      repo = "spotifywm";
      rev = "a2b5efd5439b0404f1836cc9a681417627531a00";
      sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
    };
  });

  spotify-wrapped-wm = import ./spotify prev spotifywm;
}
