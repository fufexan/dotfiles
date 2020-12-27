#!/bin/sh

# simple script that does things with monitors
# default is to set up a new monitor other than the default, to its right
# usage:
# 	multihead.sh [mode [arg]]
# mode:
#     add	- adds a monitor (or all connected, if no arg is given)
#     remove	- removes a monitor (or all but primary, if no arg is given)
# arg:
#     the xrandr name of the monitor (xrandr -q to list all monitors)

# this should work with both laptops and desktops, as long as it's 2 monitors
# and the primary is on the left

# default monitor
default="HDMI-0"
xrandr --output $default --primary --auto

# detect name of second monitor
connected=$(xrandr -q | grep -w connected | wc -l)
[ $connected -eq 2 ] && old=$(xrandr -q | grep -w connected | grep -v primary | awk '{print $1;}')

add() {
  xrandr --output $1 --auto --right-of $default
  xrandr --output $1 --pos 1920x400
}

remove() {
  xrandr --output $1 --off
}

case $1 in
    remove)
        case $2 in
            .+)
                new=$2
                ;;
            *)
                new=$old
        esac
        remove $new
        ;;
    *)
        case $2 in
            .+)
                new=$2
                ;;
            *)
                new=$old
        esac
        add $new
esac
