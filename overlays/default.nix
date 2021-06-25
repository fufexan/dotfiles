{ inputs }:
final: prev: {
  #discord = prev.callPackage ./discord {
  #  branch = "stable";
  #  pkgs = prev;
  #};
  kakoune-cr = prev.callPackage ./kakoune.cr { inherit inputs; };
  wine-tkg = prev.callPackage ./wine-tkg { inherit (inputs.master.legacyPackages.x86_64-linux) wineWowPackages; };
}
