# https://gitlab.com/fazzi/azzipkgs/-/blob/d872f61e8de48446f1bb8d5e21c9becebe1fb8b4/pkgs/stremio-linux-shell.nix
{

  lib,
  rustPlatform,
  openssl,
  pkg-config,
  glib,
  gettext,
  glib-networking,
  mpv,
  makeWrapper,
  nodejs,
  libadwaita,
  libepoxy,
  wrapGAppsHook4,
  webkitgtk_6_0,
  windowDecor ? false,
  src,
  version,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell";
  inherit src version;

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    outputHashes = {
      "libmpv2-5.0.3" = "sha256-EhADLuOxJe2xYEXfwYRNSlFVuuV10TxqmwsG9oZPG3c=";
    };
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
    glib
    gettext
  ];

  # build.rs compiles gschemas/translations into $HOME-derived data dir
  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    mkdir -p $out/share/stremio-linux-shell
    cp $src/data/server.js $out/share/stremio-linux-shell/server.js

    # install + compile the GSettings schema so it's found at runtime (build.rs
    # only compiles it into a throwaway dir). glib's postInstall hook then
    # relocates share/glib-2.0/schemas into share/gsettings-schemas/$name and
    # wrapGAppsHook4 adds it to the wrapper's XDG_DATA_DIRS
    install -Dm644 data/com.stremio.Stremio.gschema.xml \
      $out/share/glib-2.0/schemas/com.stremio.Stremio.gschema.xml
    glib-compile-schemas $out/share/glib-2.0/schemas

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
    maintainers = with lib.maintainers; [
      fazzi
      fufexan
    ];
    platforms = lib.platforms.linux;
  };
})
