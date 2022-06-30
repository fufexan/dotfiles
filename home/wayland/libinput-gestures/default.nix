{
  pkgs,
  config,
  ...
}: let
  wofi = "${pkgs.wofi}/bin/wofi";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in {
  home.packages = [pkgs.libinput-gestures];

  xdg.configFile."libinput-gestures.conf".text = ''
    # see https://github.com/bulletmark/libinput-gestures/blob/master/libinput-gestures.conf

    gesture swipe up 3 ${wofi} --show drun --allow-images
    gesture swipe left 3 ${hyprctl} dispatch workspace m+1
    gesture swipe right 3 ${hyprctl} dispatch workspace m-1
    gesture swipe left 4 ${hyprctl} dispatch focusmonitor l
    gesture swipe right 4 ${hyprctl} dispatch focusmonitor r
    gesture pinch in 4 ${hyprctl} dispatch fullscreen 1
    gesture pinch out 4 ${hyprctl} dispatch fullscreen 0

    swipe_threshold 0
  '';

  systemd.user.services.libinput-gestures = {
    Unit = {
      Description = "Libinput Gestures";
      PartOf = ["graphical-session.target"];
      X-Restart-Triggers = ["${config.xdg.configFile."libinput-gestures.conf".source}"];
    };

    Service = {
      Environment = "PATH=${pkgs.libinput-gestures}:/run/wrappers/bin:/${pkgs.coreutils}/bin";
      ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
      Restart = "on-failure";
    };

    Install = {WantedBy = ["graphical-session.target"];};
  };
}
