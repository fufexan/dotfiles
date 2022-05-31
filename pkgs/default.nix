inputs: final: prev: rec {
  catppuccin-gtk = prev.callPackage ./catppuccin-gtk {};

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
      patches = [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
          sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
        })
      ];
    }))
    .override {inherit (final) xwayland;};

  hyprland = inputs.hyprland.packages.${prev.system}.default.override {
    wlroots = wlroots-hyprland;
    inherit (final) xwayland;
  };

  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland-vsync.patch
      ./patches/xwayland-hidpi.patch
    ];
  });
}
