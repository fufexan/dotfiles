{
  pkgs,
  lib,
  ...
}: let
  wallpaper = builtins.fetchurl rec {
    name = "wallpaper-${sha256}.png";
    url = "https://files.catbox.moe/wn3b28.png";
    sha256 = "0f7q0aj1q6mjfh248j8dflfbkbcpfvh5wl75r3bfhr8p6015jkwq";
  };
in {
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
