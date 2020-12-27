#!/bin/sh

# small script that substitutes its python sibling, aiming to be more portable

# set wallpaper directory
wall_dir=~/Pictures/wallpapers

# pick a random wallpaper depending on season and time of the day
# get month
month=$(date +%m)
# get hour
hour=$(date +%H)
# determine season based on month
[ $month -eq 12 -o $month -le 2 ] && season="winter" || (
	[ $month -ge 3 -a $month -le 5 ] && season="spring" || (
		[ $month -ge 6 -a $month -le 8 ] && season="summer" || season="autumn"
	)
)

# check if dark or light mode has been specified
if [ $1 = "dark" -o $1 = "light" ]; then
	variant=$1
	[ $variant = "light" ] && light="-l" || light=""
else
	# perform the check automatically
	# light theme enabled from 10 am to 5 pm
	if [ $hour -ge 10 -a $hour -lt 17 ]; then
		light="-l";
		variant="light"
	else
		light="";
		variant="dark"
	fi
fi

# run pywal
wal $light -i $wall_dir/$season/$variant

# while wal takes care of GTK and xrdb-dependent applications, we have to set
# the colors of bspwm ourselves
. ~/.cache/wal/colors.sh
bspc config normal_border_color "$color1"
bspc config active_border_color "$color2"
bspc config focused_border_color "$color15"
bspc config presel_feedback_color "$color1"
