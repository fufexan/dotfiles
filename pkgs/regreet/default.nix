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
    rev = "e06f5aa1477d2f398556b99059a00209f62eca92";
    sha256 = "sha256-dqzPA3T/k9fCqYa9xbsL8mJ11NSvQQmo06sTmepNgGA=";
  };

  cargoHash = "sha256-nZYpb5DR8ntpvzsiCetV192kYbOVayEYkk0BhRStjpQ=";

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
