{ fetchzip, pkgs }:
pkgs.callPackage ./base.nix rec {
  pname = "lightcord";
  binaryName = "Lightcord";
  desktopName = "Lightcord";
  version = "0.1.4";
  src = fetchzip {
    url = "https://github.com/Lightcord/Lightcord/releases/download/v${version}/lightcord-linux-x64.zip";
    sha256 = "0llpxwabd204wgvhv7pjpx8saknpg2xyb7vjw2bnwdj20nh9w78b";
    stripRoot = false;
  };
}
