{ inputs }:

final: prev: {
  discord-electron = prev.callPackage ./discord {
    branch = "stable";
    pkgs = prev;
  };

  kakoune-cr = prev.callPackage ./kakoune.cr { inherit (inputs) kakoune-cr; };

  orchis-theme = prev.callPackage ./orchis-theme { };

  picom = prev.picom.overrideAttrs (old: {
    version = "unstable-2021-08-04";
    src = inputs.picom;
  });
}
