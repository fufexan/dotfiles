{ fetchzip, pkgs }:
pkgs.callPackage ./base.nix rec {
  pname = "lightcord";
  binaryName = "lightcord";
  desktopName = "Lightcord";

  version = "0.1.5";
  src = pkgs.fetchzip {
    url = "https://github.com/Lightcord/Lightcord/releases/download/0.1.5/lightcord-linux-x64.zip";
    sha256 = "sha256-lorjKF7RQHLt3e57CrPa4QqpztHQqsF+ijiJD5hJYTY=";
    stripRoot = false;
  };
}
