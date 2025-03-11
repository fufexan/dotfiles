{lib, ...}: {
  services.udiskie.enable = true;
  systemd.user.services.udiskie.Unit.After = lib.mkForce "graphical-session.target";
}
