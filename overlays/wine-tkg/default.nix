{ lib, wineWowPackages, fetchFromGitHub, ... }:

let
  tkg-patches = fetchFromGitHub {
    owner = "Frogging-Family";
    repo = "wine-tkg-git";
    rev = "b99c79939b180abff291e046aaf68ea27349a29c";
    sha256 = "sha256-TFkLPbKiKp7VR5r09EtY9LXvEcV5FLq9q6yJYAsyMX8=";
  };
in
(
  wineWowPackages.unstable.overrideAttrs (
    old: rec {
      patches = lib.mapAttrsToList (n: v: n) (lib.filterAttrs (n: v: v == "regular") (builtins.readDir "${tkg-patches}/wine-tkg-git/wine-tkg-patches"));
    }
  )
)
