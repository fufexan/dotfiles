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
  };
}
