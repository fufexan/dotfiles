{ lib, ... }:
{
  services.tailray.enable = true;
  systemd.user.services.tailray = {
    Unit.After = lib.mkForce "graphical-session.target";
    Service.Environment = "TAILRAY_THEME=dark";
  };
}
