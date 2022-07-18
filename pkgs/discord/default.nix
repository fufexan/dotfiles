{
  pname,
  version,
  src,
  binaryName,
  desktopName,
  webRTC ? false,
  enableVulkan ? false,
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
  electron,
  expat,
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
  openasar,
  pango,
  systemd,
  libappindicator-gtk3,
  libdbusmenu,
  vulkan-loader,
  vulkan-extension-layer,
  writeScript,
  common-updater-scripts,
  makeShellWrapper,
}: let
  inherit binaryName;
in
  stdenv.mkDerivation rec {
    inherit pname version src;

    nativeBuildInputs = [
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
      makeShellWrapper
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
      libXScrnSaver
      libappindicator-gtk3
      libdbusmenu
      vulkan-loader
      vulkan-extension-layer
    ];

    flags =
      (
        lib.optionals webRTC [
          "--flag-switches-begin"
          "--enable-features=WebRTCPipeWireCapturer${lib.optionalString enableVulkan ",Vulkan"}"
          "--flag-switches-end"
          "--enable-webrtc-pipewire-capturer"
        ]
      )
      ++ extraOptions;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,opt/${binaryName},share/pixmaps,share/icons/hicolor/256x256/apps}
      mv * $out/opt/${binaryName}

      chmod +x $out/opt/${binaryName}/${binaryName}
      patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
          $out/opt/${binaryName}/${binaryName}

      wrapProgramShell $out/opt/${binaryName}/${binaryName} \
          "''${gappsWrapperArgs[@]}" \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
          --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
          --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${binaryName}

      ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
      # Without || true the install would fail on case-insensitive filesystems
      ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${
        lib.strings.toLower binaryName
      } || true

      ln -s $out/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png
      ln -s $out/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/${pname}.png

      ln -s "${desktopItem}/share/applications" $out/share/

      runHook postInstall
    '';

    postInstall = ''
      cp -f ${openasar} $out/opt/${binaryName}/resources/app.asar

      # Create starter script for discord
      echo "#!${stdenv.shell}" > $out/bin/${binaryName}
      echo "exec ${electron}/bin/electron ${lib.concatStringsSep " " flags} $out/opt/${binaryName}/resources/app.asar \$@" >> $out/bin/${binaryName}
      chmod 755 $out/bin/${binaryName}

      wrapProgram $out/bin/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
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
      mimeTypes = ["x-scheme-handler/discord"];
    };

    meta = with lib; {
      description = "All-in-one cross-platform voice and text chat for gamers, built with latest Electron";
      homepage = "https://discordapp.com/";
      downloadPage = "https://discordapp.com/download";
      platforms = ["x86_64-linux"];
    };
  }
