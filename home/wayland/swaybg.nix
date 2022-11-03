{
  pkgs,
  lib,
  default,
  ...
}: {
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${default.wallpaper} -m fill";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
