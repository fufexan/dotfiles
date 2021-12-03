{ inputs }:

final: prev: {
  clightd = prev.clightd.overrideAttrs (o: { src = inputs.clightd; });

  orchis-theme = prev.callPackage ./orchis-theme { };

  picom = prev.picom.overrideAttrs (old: {
    version = "unstable-2021-08-04";
    src = inputs.picom;
  });

  technic-launcher = prev.callPackage ./technic.nix { };

  xwayland = prev.xwayland.overrideAttrs ({ patches ? [ ], ... }: {
    preConfigure = ''
      patch -p1 < ${./xwayland.patch}
    '';
  });
}
