{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
    bash
    coreutils
    dconf # Colors.qml reads/watches the darkman color-scheme key
    gawk
    lsof
    ripgrep
    procps
    util-linux
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
  ];

  # One process per component, so a crash in one does not take the others down.
  # notifd owns the D-Bus notification name and the client socket. The others
  # reconnect to it on their own.
  mkService =
    name: extra:
    lib.recursiveUpdate {
      Unit = {
        Description = "Quickshell ${name}";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
        After = "graphical-session.target";
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies} QML2_IMPORT_PATH=${QML2_IMPORT_PATH} QSG_RHI_BACKEND=vulkan";
        ExecStart = "${lib.getExe quickshell} -p %h/.config/quickshell/${name}.qml";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    } extra;
in
{
  home.packages = [ quickshell ];

  home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

  systemd.user.services = {
    # A stale socket file left by a crash would block notifd from binding.
    quickshell-notifd = mkService "notifd" {
      Service.ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/qs-notifd.sock";
    };
    quickshell-bar = mkService "bar" { };
    quickshell-sidebar = mkService "sidebar" { };
    quickshell-osd = mkService "osd" { };
  };
}
