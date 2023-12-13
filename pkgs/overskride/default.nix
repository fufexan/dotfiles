{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  dbus,
  gtk4,
  libadwaita,
  bluez,
  libpulseaudio,
}:
stdenv.mkDerivation (
  finalAttrs: {
    pname = "overskride";
    version = "0.5.6+date=2023-11-20";

    src = fetchFromGitHub {
      owner = "kaii-lb";
      repo = "overskride";
      rev = "73806b9949400fc3fb8e818c0341a560a4168f4d";
      hash = "sha256-rYM5zdqrJd8FaPfV9Nn6TDQW9y16HSM4eIRi+JtuYFo=";
    };

    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit (finalAttrs) src;
      name = "${finalAttrs.pname}-${finalAttrs.version}";
      hash = "sha256-5m9g7kvGa1HBSwYoIG7Qe/Xxu0qIQIqPizT9a6OereE=";
    };

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      pkg-config
      wrapGAppsHook4
      desktop-file-utils
      appstream-glib
      blueprint-compiler
      meson
      ninja
      cargo
      rustc
    ];

    buildInputs = [dbus gtk4 libadwaita bluez libpulseaudio];

    preFixup = ''
      glib-compile-schemas $out/share/gsettings-schemas/${finalAttrs.pname}-${finalAttrs.version}/glib-2.0/schemas
    '';

    meta = with lib; {
      description = "A Bluetooth and Obex client that is straight to the point, DE/WM agnostic, and beautiful";
      homepage = "https://github.com/kaii-lb/overskride";
      changelog = "https://github.com/kaii-lb/overskride/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = licenses.gpl3Only;
      mainProgram = pname;
      maintainers = with maintainers; [mrcjkb];
      platforms = platforms.linux;
    };
  }
)
