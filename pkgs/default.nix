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

  rocket-league = prev.callPackage ./rocket-league {
    wine = inputs.osu-nix.overlays."nixpkgs/wine-tkg".wine-tkg;

    inherit (inputs.osu-nix.overlays."nixpkgs/winestreamproxy") winestreamproxy;
  };

  technic-launcher = prev.callPackage ./technic-launcher { };
}
