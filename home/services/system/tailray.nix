{lib, ...}: {
  services.tailray.enable = true;
  systemd.user.services.tailray.Unit.After = lib.mkForce "graphical-session.target";
}
