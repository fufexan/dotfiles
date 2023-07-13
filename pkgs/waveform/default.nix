{
  alsa-lib,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  dpkg,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gnome2,
  gtk3,
  gtk4,
  lib,
  libX11,
  libxcb,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  stdenv,
  at-spi2-atk,
  at-spi2-core,
  autoPatchelfHook,
  wrapGAppsHook,
}: let
  mirror = "https://cdn.tracktion.com/file/tracktiondownload/waveform";
in
  stdenv.mkDerivation rec {
    pname = "waveform";
    version = "11.5.18";
    pversion = lib.concatStrings (lib.remove "." (lib.stringToCharacters version));

    src = fetchurl {
      url = "${mirror}/${pversion}/${pname}_64bit_v${version}.deb";
      sha256 = "sha256-kRqgiIfgpmkPOwAuSuxhi/H18ezgicRo+wbTWeFaweU=";
    };

    unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

    nativeBuildInputs = [
      autoPatchelfHook
      wrapGAppsHook
    ];

    # not sure how much of this all is needed
    buildInputs = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig.lib
      freetype
      gdk-pixbuf
      glib
      gnome2.GConf
      gtk3
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      libdrm
      libnotify
      libuuid
      libxcb
      libxshmfence
      mesa
      nspr
      nss
      pango
      stdenv.cc.cc.lib
    ];

    runtimeDependencies = [
      # without this, it complains about not finding libcurl
      curl.out

      # not sure if needed
      libpulseaudio.out
      gtk3
      gtk4
    ];

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';

    meta = {
      homepage = "https://www.tracktion.com/welcome/waveform-free";
      description = "Waveform DAW";
      platforms = ["x86_64-linux"];
    };
  }
