{ inputs }:
final: prev: {
  #discord = prev.callPackage ./discord {
  #  branch = "stable";
  #  pkgs = prev;
  #};
  kakoune-cr = prev.callPackage ./kakoune.cr { inherit inputs; };

  rocket-league = prev.callPackage ./rocket-league {
    wine = final.wine-tkg;
    inherit (final) winestreamproxy;
  };

  technic-launcher = prev.callPackage ./technic-launcher { };

  wine-tkg = prev.callPackage ./wine-tkg { inherit (inputs.master.legacyPackages.x86_64-linux) wineWowPackages; };

  winestreamproxy = prev.callPackage ./winestreamproxy { wine = final.wine-tkg; };
}
