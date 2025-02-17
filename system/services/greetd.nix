{
  config,
  lib,
  ...
}: {
  # greetd display manager
  services.greetd = let
    session = {
      command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
      user = "mihai";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
    };
  };

  # unlock GPG keyring on login
  # disabled as it doesn't work with autologin
  # security.pam.services.greetd.enableGnomeKeyring = true;
}
