{
  config,
  lib,
  pkgs,
  ...
}:
let
  themeScript =
    theme:
    pkgs.writeShellScript "theme-start-${theme}" ''
      ${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-${theme}'"
      cat <<EOF > ${config.xdg.configHome}/Kvantum/kvantum.kvconfig
      [General]
      theme=KvLibadwaita${lib.optionalString (theme == "dark") "Dark"}
      EOF
    '';
in
{
  systemd.user.timers = {
    theme-toggle-dark = {
      Unit.Description = "Toggle dark theme";
      Timer.OnCalendar = [
        "*-*-* 16:00:00"
      ];
      Install.WantedBy = [ "graphical-session.target" ];
    };

    theme-toggle-light = {
      Unit.Description = "Toggle light theme";
      Timer.OnCalendar = [
        "*-*-* 08:00:00"
      ];
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services = {
    theme-toggle-dark = {
      Unit.Description = "Toggle dark theme";
      Service = {
        Type = "oneshot";
        ExecStart = themeScript "dark";
        TimeoutStopSec = 5;
      };
    };
    theme-toggle-light = {
      Unit.Description = "Toggle light theme";
      Service = {
        Type = "oneshot";
        ExecStart = themeScript "light";
        TimeoutStopSec = 5;
      };
    };
  };
}
