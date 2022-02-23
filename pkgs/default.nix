final: prev: {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl { };

  technic-launcher = prev.callPackage ./technic.nix { };

  waveform = prev.callPackage ./waveform { };

  xwayland = prev.xwayland.overrideAttrs ({ patches ? [ ], ... }: {
    preConfigure = ''
      patch -p1 < ${./patches/xwayland.patch}
    '';
  });
}
