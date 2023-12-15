{
  stdenv,
  rustPlatform,
  lib,
  fetchFromGitHub,
  ncurses,
  perl,
  pkg-config,
  python3,
  fontconfig,
  installShellFiles,
  openssl,
  libGL,
  libX11,
  libxcb,
  libxkbcommon,
  xcbutil,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilwm,
  wayland,
  zlib,
  libiconv,
  nixosTests,
  runCommand,
  vulkan-loader,
}: let
  commit = "e3cd2e93d0ee5f3af7f3fe0af86ffad0cf8c7ea8";
in
  rustPlatform.buildRustPackage rec {
    pname = "wezterm";
    version = "unstable-${commit}";

    src = fetchFromGitHub {
      owner = "wez";
      repo = pname;
      rev = commit;
      fetchSubmodules = true;
      hash = "sha256-sj3S1fWC6j9Q/Yc+4IpLbKC3lttUWFk65ROyCdQt+Zc=";
    };

    postPatch = ''
      echo ${version} > .tag

      # tests are failing with: Unable to exchange encryption keys
      rm -r wezterm-ssh/tests
    '';

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        # "image-0.24.5" = "sha256-fTajVwm88OInqCPZerWcSAm1ga46ansQ3EzAmbT58Js=";
        "xcb-1.2.1" = "sha256-zkuW5ATix3WXBAj2hzum1MJ5JTX3+uVQ01R1vL6F1rY=";
        "xcb-imdkit-0.2.0" = "sha256-L+NKD0rsCk9bFABQF4FZi9YoqBHr4VAZeKAWgsaAegw=";
      };
    };

    nativeBuildInputs = [
      installShellFiles
      ncurses # tic for terminfo
      pkg-config
      python3
    ];

    buildInputs =
      [
        fontconfig
        zlib
      ]
      ++ lib.optionals stdenv.isLinux [
        libX11
        libxcb
        libxkbcommon
        openssl
        wayland
        xcbutil
        xcbutilimage
        xcbutilkeysyms
        xcbutilwm # contains xcb-ewmh among others
      ];

    buildFeatures = ["distro-defaults"];

    env.NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework System";

    postInstall = ''
      mkdir -p $out/nix-support
      echo "${passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages

      install -Dm644 assets/icon/terminal.png $out/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
      install -Dm644 assets/wezterm.desktop $out/share/applications/org.wezfurlong.wezterm.desktop
      install -Dm644 assets/wezterm.appdata.xml $out/share/metainfo/org.wezfurlong.wezterm.appdata.xml

      install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
      installShellCompletion --cmd wezterm \
        --bash assets/shell-completion/bash \
        --fish assets/shell-completion/fish \
        --zsh assets/shell-completion/zsh

      install -Dm644 assets/wezterm-nautilus.py -t $out/share/nautilus-python/extensions
    '';

    preFixup = lib.optionalString stdenv.isLinux ''
      patchelf \
        --add-needed "${libGL}/lib/libEGL.so.1" \
        --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
        $out/bin/wezterm-gui
    '';

    passthru = {
      tests = {
        all-terminfo = nixosTests.allTerminfo;
        terminal-emulators = nixosTests.terminal-emulators.wezterm;
      };
      terminfo =
        runCommand "wezterm-terminfo"
        {
          nativeBuildInputs = [ncurses];
        } ''
          mkdir -p $out/share/terminfo $out/nix-support
          tic -x -o $out/share/terminfo ${src}/termwiz/data/wezterm.terminfo
        '';
    };

    meta = with lib; {
      description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
      homepage = "https://wezfurlong.org/wezterm";
      license = licenses.mit;
      mainProgram = "wezterm";
      maintainers = with maintainers; [SuperSandro2000 mimame];
    };
  }
