#!/bin/sh

# Made by fufexan
# Calls rofi for a confirmation

rofi_command="rofi -theme $HOME/.local/share/rofi/layouts/two.rasi"

# Options
yes=""
no=""

# Variable passed to rofi
options="$yes\n$no"

chosen="$(echo -e "$options" | $rofi_command -p '' -dmenu -selected-row 1)"
case $chosen in
    $yes)
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
