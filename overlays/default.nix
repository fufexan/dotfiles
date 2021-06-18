final: prev: {
  #discord = prev.callPackage ./discord {
  #  branch = "stable";
  #  pkgs = prev;
  #};
  kakoune-cr = prev.callPackage ./kakoune.cr { };
}
