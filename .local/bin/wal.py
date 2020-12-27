#!/usr/bin/env python

# Simple script for wal api
# NOTE: I no longer use this script, as I have moved to NixOS and Python's
# harder to set up. Also I see not much benefit from using this python script
# rather than the newer shell script I've written.

from datetime import datetime
import pywal
import sys
import os

def main():
    # Set default color
    # Get either from the second arg, either set the default to dark
    try:
        color = sys.argv[1]
    except:
        color = "dark"

    month = datetime.today().month
    if month in range(1, 3) or month == 12:
        season = "winter"
    elif month in range(3, 6):
        season = "spring"
    elif month in range(6, 9):
        season = "summer"
    else:
        season = "autumn"

    # Validate image and pick a random image if a
    # directory is given below.
    image = pywal.image.get("~/Pictures/wallpapers/" + season + "/" + color)

    # Return a dict with the palette.
    # Set quiet to 'True' to disable notifications.
    colors = pywal.colors.get(image)

    # Apply the palette to all open terminals.
    # Second argument is a boolean for VTE terminals. (vte_fix)
    # Set it to true if the terminal you're using is
    # VTE based. (xfce4-terminal, termite, gnome-terminal.)
    pywal.sequences.send(colors, vte_fix=False)

    # Export all template files.
    pywal.export.every(colors)

    # Reload individual programs.
    pywal.reload.polybar()
    pywal.reload.xrdb()

    # Set the wallpaper.
    pywal.wallpaper.change(image)

    # Set Discord css if you use a theme injector (EnhancedDiscord, etc)
    #os.system('pywal-discord')

    # Set polybar and rofi colorscheme
    os.system("polybar.sh" + color)
    os.system("ln -sf ~/.cache/wal/rofi-colors-" + color + ".rasi ~/.config/rofi/colorschemes/default.rasi")

main()
