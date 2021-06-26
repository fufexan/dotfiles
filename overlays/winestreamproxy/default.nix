{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, wine
}:

stdenv.mkDerivation rec {
  pname = "winestreamproxy";
  version = "unstable-2020-12-25";

  src = fetchFromGitHub {
    owner = "openglfreak";
    repo = pname;
    rev = "56bee898bbbfa0f43fc4ade5481238e421084f8d";
    sha256 = "sha256-72VM34/53hjZvu3bkwRQ1vZfBE7hOSxAOQLcSXR2KeU=";
  };

  nativeBuildInputs = [ pkg-config wine ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Program for Wine that forwards messages between a named pipe client and a unix socket server";
    homepage = "https://github.com/openglfreak/winestreamproxy";
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = with lib.platforms; [ "i686-linux" "x86_64-linux" ];
  };
}
