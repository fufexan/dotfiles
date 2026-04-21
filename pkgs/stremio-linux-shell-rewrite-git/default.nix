# Borrowed from https://gitlab.com/fazzi/azzipkgs/-/blob/main/pkgs/stremio-linux-shell-rewrite-git.nix?ref_type=heads
{
  lib,
  fetchFromGitHub,
  symlinkJoin,
  rustPlatform,
  openssl,
  pkg-config,
  mpv,
  makeWrapper,
  nodejs,
  libadwaita,
  libepoxy,
  wrapGAppsHook4,
  cef-binary,
  libGL,
  addDriverRunpath,
  windowDecor ? false,
  ...
}:
let
  # Follow upstream
  # https://github.com/Stremio/stremio-linux-shell/blob/f2499ad63f28858d913e2776befbcd029900fd5f/flatpak/com.stremio.Stremio.Devel.json#L143
  cefPinned = cef-binary.override {
    version = "145.0.22";
    gitRevision = "0fa8d1b";
    chromiumVersion = "145.0.7632.45";

    srcHashes = {
      aarch64-linux = "";
      x86_64-linux = "sha256-2c8RdAsv8Uag/+06sxldd5oCFHqUJUb0kCFB44PxMwY=";
    };
  };
  # cef-rs expects the files in a specific layout
  cefPath = symlinkJoin {
    name = "stremio-cef-target";
    paths = [
      "${cefPinned}/Resources"
      "${cefPinned}/Release"
    ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell-rewrite-git";
  src = fetchFromGitHub {
    owner = "fufexan";
    repo = "stremio-linux-shell";
    rev = "00c1e04d87d00e106d6e295776e6f72083649fa4";
    hash = "sha256-FF7l+PbXVMNdNn7Klt0Pgkr6MqSdc+n3BPoP1g8sb1Y=";
  };
  version = "0-unstable-${builtins.substring 0 8 finalAttrs.src.rev}";

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    outputHashes = {
      # cef hash is missing because it's fetched at build time. We don't actually
      # use this because we use cefPath above. It annoyingly still needs the hash.
      "cef-145.0.0+145.0.22" = "sha256-ShWwn8BRFckk3CJuHWiOTMAuhizI6V17st+yqDwR2tM=";
    };
  };

  buildInputs = [
    libadwaita
    libepoxy
    openssl
    mpv
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    makeWrapper
    pkg-config
  ];

  # Don't download CEF during build
  buildFeatures = [ "offline-build" ];
  # use packaged CEF
  env.CEF_PATH = cefPath;

  postInstall = ''
    mkdir -p $out/share/applications
    cp data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    mv $out/bin/stremio-linux-shell $out/bin/stremio
  '';

  # Node.js is required to run `server.js`
  # Add to `gappsWrapperArgs` to avoid two layers of wrapping.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}" \
      --set SERVER_PATH "$src/data/server.js" \
      ${lib.optionalString (!windowDecor) "--add-flags '--no-window-decorations'"}
    )
  '';

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://github.com/Stremio/stremio-linux-shell";
    license = with lib.licenses; [
      gpl3Only
      # server.js is unfree
      unfree
    ];
    maintainers = lib.maintainers.fazzi;
    platforms = lib.platforms.linux;
  };
})
