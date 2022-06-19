inputs: final: prev: let
  wlroots-patches = [
    (prev.fetchpatch {
      url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
      sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
    })
  ];

  hp = inputs.hyprland.packages.${prev.system};
in rec {
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

  gamescope = prev.callPackage ./gamescope {};

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  hyprland = hp.default.override {
    wlroots =
      (hp.wlroots.overrideAttrs (
        _: {patches = wlroots-patches;}
      ))
      .override {inherit (final) xwayland;};
    inherit (final) xwayland;
  };

  technic-launcher = prev.callPackage ./technic.nix {};

  tlauncher = prev.callPackage ./tlauncher.nix {};

  waveform = prev.callPackage ./waveform {};

  wlroots = prev.wlroots.overrideAttrs (_: {patches = wlroots-patches;});

  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland-vsync.patch
      ./patches/xwayland-hidpi.patch
    ];
  });
}
