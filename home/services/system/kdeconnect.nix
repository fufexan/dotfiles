{lib, ...}: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  systemd.user.services = {
    kdeconnect.Unit.After = lib.mkForce ["graphical-session.target"];
    kdeconnect-indicator.Unit.After = lib.mkForce ["graphical-session.target"];
  };
}
