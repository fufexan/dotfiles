{pkgs, ...}: let
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    ICON="/run/current-system/sw/share/icons/Adwaita/48x48/legacy/applets-screenshooter-symbolic.symbolic.png"
    COPY="wl-copy -t image/png"

    filename() {
      echo "$XDG_PICTURES_DIR/Screenshots/$(date '+%F_%R')_$1.png"
    }

    dst() {
      dunstify -t 5000 -A 'edit,Edit' -i $ICON "Screenshot" "$1 captured!"
    }

    mkdir -p "$XDG_PICTURES_DIR/Screenshots"

    if [[ $1 == "area" ]]; then
      F=$(filename "area")

      grim -g "$(slurp)" - | tee $F | $COPY
      RES=$(dst "Area")

      if [[ $RES == "edit" ]]; then
        swappy -f $F
      fi
    elif [[ $1 == "monitor" ]]; then
      F=$(filename "monitor")

      grim -o "$(slurp -f %o -or)" - | tee $F | $COPY
      RES=$(dst "Monitor")
      if [[ $RES == "edit" ]]; then
        swappy -f $F
      fi
    elif [[ $1 == "all" ]]; then
      F=$(filename "all")

      grim - | tee $F | $COPY
      RES=$(dst "All monitors")

      if [[ $RES == "edit" ]]; then
        swappy -f $F
      fi

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
in
  screenshot
