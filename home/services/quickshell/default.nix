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
    gawk
    ripgrep
    procps
    util-linux
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
  ];
in
{
  home.packages = [ quickshell ];

  home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      PartOf = [
        "tray.target"
        "graphical-session.target"
      ];
      After = "graphical-session.target";
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies} QML2_IMPORT_PATH=${QML2_IMPORT_PATH}";
      ExecStart = lib.getExe quickshell;
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
