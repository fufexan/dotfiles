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
in {
  home.packages = [package];

  xdg.configFile."eww/eww.yuck".text = import ./eww_yuck.nix args attrs;
  xdg.configFile."eww/eww.scss".source = ./eww.scss;
  xdg.configFile."eww/images".source = ./images;

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww";
      # not yet implemented
      # PartOf = ["tray.target"];
      PartOf = ["graphical-session.target"];
      X-Restart-Triggers = ["${config.xdg.configFile."eww/eww.yuck".source}"];
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
