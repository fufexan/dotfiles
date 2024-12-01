{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services.wluma = {
    Unit = {
      Description = "Automatic backlight control";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = lib.getExe pkgs.wluma;
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  xdg.configFile."wluma/config.toml".source = (pkgs.formats.toml {}).generate "wluma-config" {
    als.iio = {
      path = "/sys/bus/iio/devices";
      thresholds = {
        "0" = "night";
        "10" = "dark";
        "20" = "dim";
        "100" = "normal";
        "200" = "bright";
        "500" = "outdoors";
      };
    };

    output.backlight = [
      {
        capturer = "none";
        name = "eDP-1";
        path = "/sys/class/backlight/amdgpu_bl0";
      }
    ];

    # need to fix ddcutil first
    # output.ddcutil = [
    #   {
    #     capturer = "none";
    #     name = "BenQ BL2283";
    #   }
    # ];
  };
}
