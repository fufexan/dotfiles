#!/usr/bin/env cached-nix-shell
#! nix-shell -i bash -p libnotify maim xdotool xclip

# screenshot tool
# single screen, all screens or selected area

rofi_command="rofi -theme $HOME/.local/share/rofi/layouts/three.rasi"

# options
screen=""
area=""
full=""

# variable passed to rofi
options="$screen\n$area\n$full"
clip="xclip -selection clipboard -t image/png"
save="tee ~/Pictures/ss/$(date +%Y.%m.%d-%H.%M)_"

if [ $1 == "rofi" ]; then
	chosen="$(echo -e "$options" | $rofi_command -p '' -dmenu-selected-row 1)"
else
	chosen=$1
	area="area"
	full="full"
	screen="screen"
fi

case $chosen in
  $screen)
    MONITORS=$(xrandr | grep -o '[0-9]*x[0-9]*[+-][0-9]*[+-][0-9]*')
    # Get the location of the mouse
    XMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $2}')
    YMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $4}')

    for mon in ${MONITORS}; do
      # Parse the geometry of the monitor
      MONW=$(echo ${mon} | awk -F "[x+]" '{print $1}')
      MONH=$(echo ${mon} | awk -F "[x+]" '{print $2}')
      MONX=$(echo ${mon} | awk -F "[x+]" '{print $3}')
      MONY=$(echo ${mon} | awk -F "[x+]" '{print $4}')
      # Use a simple collision check
      if (( ${XMOUSE} >= ${MONX} )); then
      if (( ${XMOUSE} <= ${MONX}+${MONW} )); then
        if (( ${YMOUSE} >= ${MONY} )); then
        if (( ${YMOUSE} <= ${MONY}+${MONH} )); then
          # We have found our monitor!
          maim -g "${MONW}x${MONH}+${MONX}+${MONY}" -d 0.2 | eval $save"single.png" | eval $clip
          scr="Monitor"
        fi
        fi
      fi
      fi
    done
  ;;
  $area)
    maim -Bus | eval $save"sel.png" | eval $clip
    scr="Area"
  ;;
  $full)
    maim -Bd 0.2 | eval $save"full.png" | eval $clip
    scr="All screens"
  ;;
esac

# TODO: handle canceling of screenshot
notify-send -u low $scr" screenshot taken!"

