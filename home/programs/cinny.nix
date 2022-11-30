{pkgs, ...}: {
  # use Cinny Matrix client
  # create systemd service that serves it on localhost:9999
  systemd.user.services.cinny = {
    Unit.Description = "Cinny Service";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.darkhttpd}/bin/darkhttpd ${pkgs.cinny} --addr 127.0.0.1 --port 9999";
      TimeoutStopSec = 5;
    };
    Install.WantedBy = ["default.target"];
  };
}
