{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  makeDesktopItem,
}: let
  pname = "webcord";
  version = "3.6.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/SpacingBat3/WebCord/releases/download/v${version}/WebCord-${version}-x64.AppImage";
    sha256 = "sha256-3QbFAdpOEdX8ij3XFyKIgmXvprjksiPhdQq8OusT6UU=";
  };

  appimageContents = appimageTools.extractType2 {inherit name src;};

  desktopItem = makeDesktopItem {
    name = "webcord";
    exec = "${pname} %u";
    icon = "webcord";
    desktopName = "WebCord";
    genericName = "Internet Messenger";
    comment = meta.description;
    categories = ["Network" "InstantMessaging" "Chat"];
    startupWMClass = "webcord";
    mimeTypes = ["x-scheme-handler/discord"];
  };

  meta = with lib; {
    description = "A Discord and Fosscord electron-based client implemented without Discord API";
    homepage = "https://github.com/SpacingBat3/WebCord";
    license = licenses.mit;
    maintainers = with maintainers; [fufexan];
    platforms = ["x86_64-linux"];
  };
in
  appimageTools.wrapType2 rec {
    inherit name src meta;

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}

      # wrapProgram "$out/bin/${pname}" \
      #   --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"

      # install ${desktopItem} $out/share/applications
    '';
  }
