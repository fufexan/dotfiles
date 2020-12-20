#!/bin/sh

# git gpg signing
eval $(gpg-agent --daemon)

#
# start BSPWM
#
sxhkd &
exec dbus-launch --exit-with-x11 bspwm
