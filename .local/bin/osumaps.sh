#!/bin/sh

# simple script that moves .osz files to osu!'s Songs directory

# Downloads folder
DL=~/Downloads
# osu! Songs folder
OSZ=~/Games/osu/drive_c/osu/Songs

mv $DL/*.osz $OSZ/
