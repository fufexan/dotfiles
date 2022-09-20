inputs: _: prev: {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  discord-electron-openasar = prev.callPackage ./discord {
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

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  lapce = prev.lapce.overrideAttrs (old: rec {
    pname = "lapce";
    version = "0.2.0";

    src = prev.fetchFromGitHub {
      owner = "lapce";
      repo = "lapce";
      rev = "7867f5050e9d3102121b5746de77805324d3b07f";
      sha256 = "sha256-qm5HDBSMTPS3lLvaNFie+SPAf4fHirn1qAHHQRZ5xIg=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (_: {
      inherit src;
      name = "${pname}-${version}-vendor.tar.gz";
      outputHash = "sha256-k/CVJ1TGD3/L/m53bxV6J4zckTDfzT0IiUzgyRDI2BE=";
    });

    nativeBuildInputs = old.nativeBuildInputs ++ [prev.makeWrapper];

    postInstall = ''
      install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/lapce.svg
      wrapProgram $out/bin/lapce \
        --prefix XDG_DATA_DIRS : "${prev.gtk3}/share/gsettings-schemas/${prev.gtk3.name}/"
    '';
  });

  technic-launcher = prev.callPackage ./technic.nix {};

  tlauncher = prev.callPackage ./tlauncher.nix {};

  waveform = prev.callPackage ./waveform {};

  sway-hidpi = import ./sway-hidpi.nix prev;
}
