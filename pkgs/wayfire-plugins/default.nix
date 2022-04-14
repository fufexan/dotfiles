{ lib
, stdenv
, meson
, ninja
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "wayfire-plugins";
  version = "unstable-2021-01-22";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = pname;
    rev = "763109bb431c7cefa445dc17bdc1f5fdd7a769ad";
    sha256 = lib.fakeHash;
  };

  nativeBuildInputs = [ meson ninja ];

  meta = {
    homepage = "https://github.com/ammen99/wayfire-plugins";
    description = "A repository for Wayfire plugins which I use to tweak my own desktop";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = lib.maintainers.fufexan;
  };
}
