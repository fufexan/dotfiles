{
  environment.etc."xdg/hypr/per_host.lua".text =
    let
      # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
      accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
    in
    ''
      ---------------------------
      ---- HOST-SPECIFIC (io) ---
      ---------------------------

      hl.monitor({
        output   = "DP-1",
        mode     = "preferred",
        position = "auto-left",
        scale    = "auto",
      })
      hl.monitor({
        output   = "DP-2",
        mode     = "preferred",
        position = "auto-left",
        scale    = "auto",
      })
      hl.monitor({
        output   = "eDP-1",
        mode     = "preferred",
        position = "auto",
        scale    = 1.6,
      })

      hl.device({
        name            = "elan2841:00-04f3:31eb-touchpad",
        accel_profile   = "custom ${accelpoints}",
        scroll_points   = "${accelpoints}",
        natural_scroll  = true,
      })
    '';
}
