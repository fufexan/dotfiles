{ inputs }:

final: prev: {
  discord-electron = prev.callPackage ./discord {
    branch = "stable";
    pkgs = prev;
  };

  kakoune-cr = prev.callPackage ./kakoune.cr { inherit (inputs) kakoune-cr; };

  picom-jonaburg = prev.picom.overrideAttrs (
    old: { src = inputs.picom-jonaburg; }
  );

}
