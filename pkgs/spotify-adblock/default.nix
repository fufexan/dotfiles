{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fufexan";
    repo = pname;
    rev = "d12be4b87e949359d6b9fd044145454d5e6c9c8f";
    sha256 = "sha256-n/JAbpyr9H8fu5pjc5YvCwXXWTweTzkdZE0uAtuNu88=";
  };

  cargoHash = "sha256-2cifA/MRwimeedWfhbnmFucz02W8+b6BTc94wFNW/50=";

  meta = {
    homepage = "https://github.com/abba23/spotify-adblock";
    description = "Spotify adblocker";
    license = lib.licenses.unfree;
    maintainer = lib.maintainers.fufexan;
  };
}
