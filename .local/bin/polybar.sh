#!/bin/sh

# kill running bar(s)
pkill polybar >/dev/null;
echo bars killed

# wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# start new default bar on default monitor
polybar dark &
echo started primary

# if a second monitor is connected, start another bar on it
if [ $(xrandr -q | grep -w connected | grep -v primary | wc -l) -ge 1 ]; then
	polybar -c ~/.config/polybar/external dark &
	echo started secondary
fi
