{
  config,
  inputs,
  lib,
  pkgs,
  ...
} @ args: let
  swayidleCfg = config.systemd.user.services.swayidle.Install.WantedBy;

  apply-hm-env = pkgs.writeShellScriptBin "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != []) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
        export ${k}=${v}
      '')
      config.home.sessionVariables)}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  # crude approach
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    ICON="/run/current-system/sw/share/icons/Adwaita/48x48/legacy/applets-screenshooter-symbolic.symbolic.png"
    COPY="wl-copy -t image/png"

    filename() {
      echo "$XDG_PICTURES_DIR/Screenshots/$(date '+%F_%R')_$1.png"
    }

    mkdir -p "$XDG_PICTURES_DIR/Screenshots"
    if [[ $1 == "area" ]]; then
      F=$(filename "area")
      grim -g "$(slurp)" - | tee $F | $COPY
      swappy -f $F
    elif [[ $1 == "monitor" ]]; then
      F=$(filename "monitor")
      grim -o "$(slurp -f %o -or)" - | tee $F | $COPY
      swappy -f $F
    elif [[ $1 == "all" ]]; then
      F=$(filename "all")
      grim - | tee $F | $COPY
      swappy -f $F

    # recording still needs work
    elif [[ $1 == "rec" ]]; then
      mkdir -p "$XDG_VIDEOS_DIR/Screenrecs"
      filename() {
        echo "$XDG_VIDEOS_DIR/Screenrecs/$(date '+%F_%R')_$1"
      }
      AUDIO="-a $(pulsemixer --list-sources | rg Monitor | awk '{print $3}' | sed 's/,//g')"

      if [[ $2 == "monitor" ]]; then
        F=$(filename "monitor.mp4")
        wf-recorder -o "$(slurp -f %o -or)" $AUDIO -f $F
      elif [[ $2 == "area" ]]; then
        F=$(filename "area.gif")
        wf-recorder -g "$(slurp)" -c gif -f $F || notify-send "Screenshot" "Wrong area!" -i $ICON
      fi
    fi
  '';
in {
  home.packages = with pkgs; [
    hyprland

    grim
    libnotify
    light
    playerctl
    pulsemixer
    screenshot
    slurp
    swappy
    wf-recorder
    wl-clipboard
    wlogout

    apply-hm-env
  ];

  xdg.configFile."hypr/hyprland.conf".text = import ./config.nix args;

  # allow swayidle to be started along with Hyprland
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["sway-session.target" "hyprland-session.target"];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}
