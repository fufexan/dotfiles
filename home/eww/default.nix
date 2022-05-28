{
  config,
  pkgs,
  inputs,
  ...
}: let
  package = inputs.eww.packages.${pkgs.system}.eww-wayland;

  startscript = ''
    eww daemon
    eww open bar
  '';
in {
  home.packages = [package];

  xdg.configFile."eww/eww.yuck".text = import ./eww_yuck.nix pkgs;
  xdg.configFile."eww/eww.scss".text = import ./eww_scss.nix;
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
      Environment = "PATH=${package}/bin:${pkgs.gawk}/bin:${pkgs.ripgrep}/bin:/run/wrappers/bin:/${pkgs.coreutils}/bin";
      ExecStart = let
        scriptPkg = pkgs.writeShellScriptBin "eww-start" startscript;
      in "${scriptPkg}/bin/eww-start";
      ExecStop = "${pkgs.procps}/bin/pkill eww";
      Restart = "on-failure";
    };

    Install = {WantedBy = ["graphical-session.target"];};
  };
}
