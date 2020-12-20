#!/bin/bash

#echo passed arguments to log
echo $@ >> ~/.cache/osuhandler.log

#Execute osu!.exe in correct wine prefix and append uri
#$@ is the variable which stores all passed arguments
WINE=~/.local/share/lutris/runners/wine/tkg-osu-4.6-x86_64/bin/wine
WINEPREFIX=$HOME/Games/osu $wine "$WINEPREFIX/drive_c/osu/osu!.exe" $@
