{ inputs }:

final: prev: {
  technic-launcher = prev.callPackage ./technic.nix { };

  xwayland = prev.xwayland.overrideAttrs ({ patches ? [ ], ... }: {
    preConfigure = ''
      patch -p1 < ${./patches/xwayland.patch}
    '';
  });
}
