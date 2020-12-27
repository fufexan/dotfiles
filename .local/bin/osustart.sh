#!/bin/sh

# for some reason osu lags when notifications are displayed (even if not from dunst), so we pause
# the notifications for a lag-free gaming session
# LATER EDIT: turns out to be the compositor's fault. turning compositing off
# and receiving notifications there is no lag or performance drop
# in recent commits I have enabled the latest picom from tryone144, which
# automatically stops compositing when an application is fullscreen (or can be
# set to do that)

# still, if you prefer not to receive notifications, uncomment the command below
#dunstify DUNST_COMMAND_PAUSE

# facilitate Discord Rich Presence from under Wine to the Linux Discord
# application: download winediscordipcbridge.exe from https://github.com/0e4ef622/wine-discord-ipc-bridge
# and place it in <your_osu_install_directory>. then edit the commands below to
# correspond with your setup
export WINEPREFIX=$HOME/Games/osu
export WINE=$HOME/.local/share/lutris/runners/wine/lutris-5.7-11-x86_64/bin/wine
$WINE $WINEPREFIX/drive_c/osu/winediscordipcbridge.exe &
# NOTE: Discord has to be running before you start osu! in order for it to pick
# the game up
