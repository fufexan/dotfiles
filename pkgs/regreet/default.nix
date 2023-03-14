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
    rev = "c70127ea991e61dd36643b486ba208e8894671cd";
    sha256 = "sha256-MB7ErANaZuAL4J2nuC7dt7ydspBB+ecZvE9NZOs54Sk=";
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
