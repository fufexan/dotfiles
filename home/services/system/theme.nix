{
  lib,
  pkgs,
  ...
}: {
  systemd.user.timers = {
    theme-toggle-dark = {
      Unit.Description = "Toggle dark theme";
      Timer.OnCalendar = [
        "*-*-* 18:00:00"
      ];
      Install.WantedBy = ["graphical-session.target"];
    };

    theme-toggle-light = {
      Unit.Description = "Toggle light theme";
      Timer.OnCalendar = [
        "*-*-* 06:00:00"
      ];
      Install.WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.services = {
    theme-toggle-dark = {
      Unit.Description = "Toggle dark theme";
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\"";
        TimeoutStopSec = 5;
      };
    };
    theme-toggle-light = {
      Unit.Description = "Toggle light theme";
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme \"'prefer-light'\"";
        TimeoutStopSec = 5;
      };
    };
  };
}
