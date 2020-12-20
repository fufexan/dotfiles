#!/bin/sh

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

rofi_command="rofi -theme $HOME/.config/rofi/android/five.rasi"
confirm="$HOME/.config/rofi/scripts/confirm.sh"

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
        $confirm && shutdown now
        ;;
    $reboot)
        $confirm && reboot
        ;;
    $lock)
        i3lock
        ;;
    $suspend)
		$confirm && (playerctl pause ; systemctl suspend)
        ;;
    $logout)
        $confirm && bspc quit
        ;;
	*)
esac

