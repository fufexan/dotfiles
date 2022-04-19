_: prev: {
  gdb-frontend = prev.callPackage ./gdb-frontend {};
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  discord-canary-electron = prev.callPackage ./discord rec {
    inherit (prev.discord-canary) src version pname;
    binaryName = "DiscordCanary";
    desktopName = "Discord Canary";
    extraOptions = [
      "--disable-gpu-memory-buffer-video-frames"
      "--enable-accelerated-mjpeg-decode"
      "--enable-accelerated-video"
      "--enable-gpu-rasterization"
      "--enable-native-gpu-memory-buffers"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
    ];
  };

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
