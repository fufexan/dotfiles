{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  # hyprqt6engine is a QPlatformTheme plugin that gets dlopen'd into Qt apps, so
  # it must be ABI-compatible with them. hyprwm builds it (and hyprutils/hyprlang)
  # with gcc16Stdenv, but nixpkgs' Qt apps still use the default (gcc15) stdenv.
  # The plugin then needs newer libstdc++ symbols (GLIBCXX_3.4.36) that can't
  # resolve against the host app's already-loaded gcc15 libstdc++, so the plugin
  # silently fails to load and Qt falls back to its default (light) palette.
  # Rebuild the whole chain with the default stdenv so the plugin only needs
  # symbols the host apps already provide. Also pull in KF6 ColorScheme/Config so
  # it can parse Breeze's KColorScheme .colors files (else it can't read them).
  inherit (pkgs) stdenv;
  hyprutils = pkgs.hyprutils.override { gcc16Stdenv = stdenv; };
  hyprlang = pkgs.hyprlang.override {
    gcc16Stdenv = stdenv;
    inherit hyprutils;
  };
  hyprqt6engine = stdenv.mkDerivation {
    pname = "hyprqt6engine";
    version = "0-unstable-2026-08-11";
    # tack-patched source (portal-follow patch); built here rather than using the
    # flake's gcc16 package, for the ABI reason above.
    src = inputs.hyprqt6engine;
    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
    ];
    buildInputs = [
      hyprlang
      hyprutils
      pkgs.qt6Packages.qtbase
      pkgs.kdePackages.kconfig
      pkgs.kdePackages.kcolorscheme
    ];
    dontWrapQtApps = true;
    cmakeFlags = [ "-DPLUGINDIR=${placeholder "out"}/lib/qt-6" ];
  };
  colorSchemes = "${pkgs.kdePackages.breeze}/share/color-schemes";
in
{
  home.packages = [
    hyprqt6engine
    # Breeze ships the light/dark KColorSchemes that KColorScheme picks between
    pkgs.kdePackages.breeze
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "hyprqt6engine";
    QT_STYLE_OVERRIDE = lib.mkForce null;
    # let Qt find the hyprqt6engine platformtheme/style plugins
    QT_PLUGIN_PATH = "${hyprqt6engine}/lib/qt-6";
  };

  # home.sessionVariables only reach login shells (via hm-session-vars.sh), so
  # shell-launched Qt apps go dark but dbus/systemd-activated ones (kdeconnectd,
  # the tray) do not. UWSM sources ~/.config/uwsm/env-hyprland at session start
  # and exports it into the systemd user + dbus activation environment, so put
  # the Qt vars here too to cover every launch path.
  xdg.configFile."uwsm/env-hyprland".text = ''
    export QT_QPA_PLATFORMTHEME=hyprqt6engine
    export QT_PLUGIN_PATH=${hyprqt6engine}/lib/qt-6''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}
  '';

  # hyprqt6engine config (hyprlang). color_scheme left empty so the patched
  # engine follows the freedesktop color-scheme preference (set by darkman) and
  # switches between color_scheme_light/dark live. Fusion repaints on the change.
  xdg.configFile."hypr/hyprqt6engine.conf".text = ''
    theme {
        style = Fusion
        icon_theme = ${config.gtk.iconTheme.name}
        # match the GTK desktop font; the engine otherwise forces Sans Serif 11,
        # which enlarged Quickshell text that inherits the app default font.
        font = ${config.gtk.font.name}
        font_size = ${toString config.gtk.font.size}
        color_scheme =
        color_scheme_light = ${colorSchemes}/BreezeLight.colors
        color_scheme_dark = ${colorSchemes}/BreezeDark.colors
    }
  '';
}
