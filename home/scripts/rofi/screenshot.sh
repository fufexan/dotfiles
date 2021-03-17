#!/bin/sh

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

## Modified by fufexan

rofi_command="rofi -theme $HOME/.local/share/rofi/layouts/three.rasi"

# Options
screen=""
area=""
full=""

# Variable passed to rofi
options="$screen\n$area\n$full"

chosen="$(echo -e "$options" | $rofi_command -p '' -dmenu -selected-row 1)"
case $chosen in
    $screen)
		~/.local/bin/maim_monitor.sh
        ;;
    $area)
        maim -Bus | tee ~/Pictures/ss/$(date +%Y.%m.%d-%H.%M)_sel.png | xclip -selection clipboard -t image/png
		;;
	$full)
		maim -Bd 0.2 | tee ~/Pictures/ss/$(date +%Y.%m.%d-%H.%M)_full.png | xclip -selection clipboard -t image/png
		;;
esac
