{
  config,
  pkgs,
  inputs,
  lib,
  ...
} @ args: let
  package = inputs.eww.packages.${pkgs.system}.eww-wayland;

  startscript = ''
    eww daemon
    eww open bar
  '';

  attrs = {
    screenWidth = 2560;
    scale = 1.6;
    gaps = 5;
  };

  scripts = builtins.listToAttrs (map (e: {
      name = e;
      value = import (./. + "/scripts/${e}.nix") args;
    })
    [
      "battery"
      "bluetooth"
      "brightness"
      "memory"
      "music"
      "net"
      "pop"
      "volume"
      "workspaces"
    ]);

  ewwyuck =
    lib.concatStringsSep "\n"
    ((map (e:
        import (/. + e) (args // attrs // scripts))
      (lib.flatten (map lib.filesystem.listFilesRecursive [./modules ./windows])))
      ++ [
        ''
          (defwidget sep []
            (label :class "separ module" :text "|"))

          (defwidget workspaces []
            (literal
              :content workspace))
        ''
      ]);
in {
  home.packages = [package];

  xdg.configFile."eww/eww.yuck".text = ewwyuck;
  xdg.configFile."eww/eww.scss".source = ./eww.scss;
  xdg.configFile."eww/images".source = ./images;

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww";
      # not yet implemented
      # PartOf = ["tray.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "forking";
      Environment = "PATH=${lib.makeBinPath [package pkgs.coreutils]}:/run/wrappers/bin";
      ExecStart = let
        scriptPkg = pkgs.writeShellScriptBin "eww-start" startscript;
      in "${scriptPkg}/bin/eww-start";
      ExecStop = "${pkgs.procps}/bin/pkill eww";
      Restart = "on-failure";
    };

    Install = {WantedBy = ["graphical-session.target"];};
  };
}
