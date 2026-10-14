{
  config,
  pkgs,
  ...
}:
{
  environment.etc."xdg/hypr/per_host.lua".text = ''
    --------------------------------
    ---- HOST-SPECIFIC (ganymde) ---
    --------------------------------

    hl.monitor({
      output   = "desc:Technical Concepts Ltd 27G64",
      mode     = "highrr",
      position = "auto",
      scale    = 1,
      bitdepth = 10,
    })
  '';

  systemd.user.services.monitor-input-watch = {
    description = "Monitor input source watcher";
    after = [ "wayland-session@hyprland.desktop.target" ];
    bindsTo = [ "wayland-session@hyprland.desktop.target" ];
    wantedBy = [ "wayland-session@hyprland.desktop.target" ];
    script = "${
      pkgs.python3.withPackages (ps: [
        ps.dbus-python
        ps.pygobject3
      ])
    }/bin/python3 ${./monitorwatch.py}";
    path = [ config.programs.hyprland.package ];

    # ddcutil-service is D-Bus activated, so at session start the name is not
    # claimable until the user bus has the session XDG_DATA_DIRS. Connecting
    # then throws ServiceUnknown and the unit stays dead for the whole
    # session, so retry instead.
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
