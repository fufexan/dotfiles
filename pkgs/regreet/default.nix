{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkg-config,
  glib,
  gtk4,
  pango,
}:
rustPlatform.buildRustPackage {
  pname = "regreet";
  version = "unstable-2023-03-12";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = "afd124b369bd36be0985f246a59df75f27b1f171";
    sha256 = "sha256-Mlyw+OI6f7YeykReEDDAKpdGHaIpl3HzUTuZjgiFzAk=";
  };

  cargoHash = "sha256-koz6bSmBvoW0R3sRgJU2Hizr2CVsGFDyqoPov/F0VL8=";

  buildFeatures = ["gtk4_8"];

  nativeBuildInputs = [pkg-config];
  buildInputs = [glib gtk4 pango];

  meta = with lib; {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [fufexan];
    platforms = platforms.linux;
  };
}
