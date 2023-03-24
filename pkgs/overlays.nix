_: prev: {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  catppuccin-plymouth = prev.callPackage ./catppuccin-plymouth {};

  discord-canary = prev.discord-canary.override {
    nss = prev.nss_latest;
    withOpenASAR = true;
  };

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  howdy = prev.callPackage ./howdy {};

  linux-enable-ir-emitter = prev.callPackage ./linux-enable-ir-emitter {};

  waveform = prev.callPackage ./waveform {};

  spotify = prev.callPackage ./spotify {};

  sway-hidpi = import ./sway-hidpi.nix prev;
}
