inputs: final: prev: rec {
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

  wlroots = prev.wlroots.overrideAttrs (_: {
    patches = [
      (prev.fetchpatch {
        url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
        sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
      })
    ];
  });

  wlroots-hyprland =
    (inputs.hyprland.packages.${prev.system}.wlroots.overrideAttrs (_: {
      src = inputs.wlroots-hyprland;
      patches = [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
          sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
        })
      ];
    }))
    .override {inherit (final) xwayland;};

  hyprland = (inputs.hyprland.packages.${prev.system}.default.override {
    wlroots = wlroots-hyprland;
    inherit (final) xwayland;
  }).overrideAttrs(_: {
    # reverts commit that switched to using wlroots from submodule
    prePatch = "";
    patches = [ ./patches/hyprland-wlroots.patch ];
    postPatch = ''
      make config
    '';
  });

  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland-vsync.patch
      ./patches/xwayland-hidpi.patch
    ];
  });
}
