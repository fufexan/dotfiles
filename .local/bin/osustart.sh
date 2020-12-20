#!/bin/sh

# for some reason osu lags when notifications are displayed (even if not from dunst), so we pause
# the notifications for a lag-free gaming session

#dunstify DUNST_COMMAND_PAUSE

export WINEPREFIX=$HOME/Games/osu
export WINE=$HOME/.local/share/lutris/runners/wine/tkg-osu-4.6-x86_64/bin/wine
$WINE $WINEPREFIX/drive_c/osu/winediscordipcbridge.exe &
