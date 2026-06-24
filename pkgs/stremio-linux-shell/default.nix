# https://gitlab.com/fazzi/azzipkgs/-/blob/d872f61e8de48446f1bb8d5e21c9becebe1fb8b4/pkgs/stremio-linux-shell.nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  glib-networking,
  mpv,
  makeWrapper,
  nodejs,
  libadwaita,
  libepoxy,
  wrapGAppsHook4,
  webkitgtk_6_0,
  windowDecor ? false,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell";
  version = "1.0.0-beta.14";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g7QZ+kYhT7NJ1HKSnV+VBDI/CGeLfJtXn0v9xWCCP/4=";
  };

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  buildInputs = [
    webkitgtk_6_0
    glib-networking
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

  postInstall = ''
    mkdir -p $out/share/applications
    cp data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    mkdir -p $out/share/stremio-linux-shell
    cp $src/data/server.js $out/share/stremio-linux-shell/server.js

    mv $out/bin/stremio-linux-shell $out/bin/stremio
  '';

  # Node.js is required to run `server.js`
  # Add to `gappsWrapperArgs` to avoid two layers of wrapping.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}" \
      --set SERVER_PATH "$out/share/stremio-linux-shell/server.js" \
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
