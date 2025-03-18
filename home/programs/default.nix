{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./browsers/zen.nix
    ./media
    ./gtk.nix
    ./office
    ./qt.nix
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    tdesktop

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWowPackages.wayland

    inputs.nix-matlab.packages.${pkgs.system}.matlab
    # FIXME: https://nixpk.gs/pr-tracker.html?pr=390243
    (zotero.overrideAttrs (self: super: {
      libPath =
        lib.makeLibraryPath (with pkgs; [
          alsa-lib
          atk
          cairo
          dbus-glib
          gdk-pixbuf
          glib
          gtk3
          libGL
          xorg.libX11
          xorg.libXcomposite
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXi
          xorg.libXrandr
          xorg.libXtst
          xorg.libxcb
          libgbm
          pango
          pciutils
        ])
        + ":"
        + lib.makeSearchPathOutput "lib" "lib" [stdenv.cc.cc];
    }))
  ];

  xdg.configFile."matlab/nix.sh".text = "INSTALL_DIR=$XDG_DATA_HOME/matlab/installation";
}
