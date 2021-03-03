#!/bin/sh

# dynamically increase/decrease border width or gaps for bspwm

case $1 in
	b)
		borders=$(bspc config border_width)
		case $2 in
			+)
				borders=`expr $borders + 1`
				;;
			-)
				borders=`expr $borders - 1`
				;;
			*)
				echo $borders
		esac

		bspc config border_width $borders
		;;
	g)
		gaps=$(bspc config window_gap)
		case $2 in
			+)
				gaps=`expr $gaps + 1`
				;;
			-)
				gaps=`expr $gaps - 1`
				;;
			*)
				echo $gaps
		esac

		bspc config window_gap $gaps
		;;
	*)
		echo "Usage: bspwm_rice.sh (b/g) (+/-)
	b - borders
	g - gaps
	+ - increase
	- - decrease"
esac
