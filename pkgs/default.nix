inputs: _: prev: rec {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  discord-electron-openasar = prev.callPackage ./discord rec {
    inherit (prev.discord) src version pname;
    openasar = prev.callPackage "${inputs.nixpkgs}/pkgs/applications/networking/instant-messengers/discord/openasar.nix" {};
    binaryName = "Discord";
    desktopName = "Discord";

    webRTC = true;
    enableVulkan = true;

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

  hyprland = let
    xwayland = prev.xwayland.overrideAttrs (_: {
      patches = [./patches/xwayland-vsync.patch];
    });
  in
    inputs.hyprland.packages.${prev.system}.hyprland.override {
      wlroots = inputs.hyprland.packages.${prev.system}.wlroots-hyprland.override {inherit xwayland;};
      inherit xwayland;
    };

  hyprland-xwayland-hidpi = import ./hyprland inputs prev;

  technic-launcher = prev.callPackage ./technic.nix {};

  tlauncher = prev.callPackage ./tlauncher.nix {};

  waveform = prev.callPackage ./waveform {};

  webcord = prev.callPackage ./webcord {};

  sway-hidpi = import ./sway-hidpi.nix prev;
}
