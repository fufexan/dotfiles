_: prev: {
  gdb-frontend = prev.callPackage ./gdb-frontend {};
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  technic-launcher = prev.callPackage ./technic.nix {};

  waveform = prev.callPackage ./waveform {};

  #wayfireApplications-unwrapped = prev.wayfireApplications-unwrapped.extend {
  #  wayfire-plugins = prev.callPackage ./wayfire-plugins { };
  #};

  xwayland = prev.xwayland.overrideAttrs (_: {
    preConfigure = ''
      patch -p1 < ${./patches/xwayland.patch}
    '';
  });
}
