{
  pname,
  version,
  src,
  binaryName,
  desktopName,
  isWayland ? true,
  enableVulkan ? true,
  extraOptions ? [],
  autoPatchelfHook,
  makeDesktopItem,
  lib,
  stdenv,
  wrapGAppsHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  electron_15,
  expat,
  ffmpeg_5,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libcxx,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libX11,
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
  libxcb,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libappindicator-gtk3,
  libdbusmenu,
  nodePackages,
  vulkan-loader,
  vulkan-extension-layer,
  writeScript,
  common-updater-scripts,
}: let
  inherit binaryName;
in
  stdenv.mkDerivation rec {
    inherit pname version src;

    nativeBuildInputs = [
      nodePackages.asar
      alsa-lib
      autoPatchelfHook
      cups
      libdrm
      libuuid
      libXdamage
      libX11
      libXScrnSaver
      libXtst
      libxcb
      libxshmfence
      mesa
      nss
      wrapGAppsHook
    ];

    dontWrapGApps = true;

    libPath = lib.makeLibraryPath [
      libcxx
      systemd
      libpulseaudio
      libdrm
      mesa
      stdenv.cc.cc
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      ffmpeg_5
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libnotify
      libX11
      libXcomposite
      libuuid
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      nspr
      nss
      libxcb
      pango
      systemd
      libXScrnSaver
      libappindicator-gtk3
      libdbusmenu
      vulkan-loader
      vulkan-extension-layer
    ];

    flags =
      (
        lib.optionals isWayland [
          "--flag-switches-begin"
          "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer${lib.optionalString enableVulkan ",Vulkan"}"
          "--flag-switches-end"
          "--ozone-platform=wayland"
          "--enable-webrtc-pipewire-capturer"
        ]
      )
      ++ extraOptions;

    installPhase =
      ''
        mkdir -p $out/{bin,usr/lib/${pname},share/pixmaps}
        ln -s discord.png $out/share/pixmaps/${pname}.png
        ln -s "${desktopItem}/share/applications" $out/share/

        # HACKS FOR SYSTEM ELECTRON
        asar e resources/app.asar resources/app
        rm resources/app.asar
        sed -i "s|process.resourcesPath|'$out/usr/lib/${pname}'|" resources/app/app_bootstrap/buildInfo.js
        sed -i "s|exeDir,|'$out/share/pixmaps',|" resources/app/app_bootstrap/autoStart/linux.js
        asar p resources/app resources/app.asar --unpack-dir '**'
        rm -rf resources/app

        # Copy Relevant data
        cp -r resources/*  $out/usr/lib/${pname}/
        mkdir -p $out/opt/${binaryName}
        cp -r resources $out/opt/${binaryName}/

        # Create starter script for discord
        echo "#!${stdenv.shell}" > $out/bin/${binaryName}
        echo "exec ${electron_15}/bin/electron ${lib.concatStringsSep " " flags} $out/usr/lib/${pname}/app.asar \$@" >> $out/bin/${binaryName}
        chmod 755 $out/bin/${binaryName}
      ''
      + ''
        wrapProgram $out/bin/${binaryName} \
            "''${gappsWrapperArgs[@]}" \
            --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
            --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${pname}
      '';

    desktopItem = makeDesktopItem {
      name = pname;
      exec = binaryName;
      icon = pname;
      inherit desktopName;
      genericName = meta.description;
      categories = ["Network" "InstantMessaging"];
      #mimeType = "x-scheme-handler/discord";
    };

    meta = with lib; {
      description = "All-in-one cross-platform voice and text chat for gamers, built with latest Electron";
      homepage = "https://discordapp.com/";
      downloadPage = "https://discordapp.com/download";
      platforms = ["x86_64-linux"];
    };
  }
