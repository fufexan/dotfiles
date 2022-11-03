{pkgs, ...}: {
  systemd.user.services.wluma = {
    Unit = {
      Description = "Backlight control";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.wluma}/bin/wluma";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  xdg.configFile."wluma/config.toml".text = ''
    [als.iio]
    path = "/sys/bus/iio/devices"
    thresholds = { 0 = "night", 20 = "dark", 250 = "normal", 500 = "bright", 80 = "dim", 800 = "outdoors" }

    [[output.backlight]]
    capturer = "wlroots"
    name = "eDP-1"
    path = "/sys/class/backlight/amdgpu_bl0"
  '';
}
