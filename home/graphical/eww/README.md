# Eww configuration

This configuration aims to provide a fully working shell replacement for
compositors/window managers. Features constantly get added and existing ones
get improved.

## 🗃️  Components

The same daemon runs multiple windows which interact with each other:

### bar

![bar](https://user-images.githubusercontent.com/36706276/192146060-9913d571-abee-4683-9f77-ea1951680cc1.gif)

### music window

![music](https://user-images.githubusercontent.com/36706276/192146077-f8da4691-9a0c-487f-9805-3fd4d55551e9.gif)

### calendar

![calendar](https://user-images.githubusercontent.com/36706276/192146093-217f68ac-fde9-400e-ade1-e9078139d327.png)

### system info

![system](https://user-images.githubusercontent.com/36706276/192146100-133b195c-d348-4fe4-a29b-ad8fc39f3b0b.png)

### volume control

![volume](https://user-images.githubusercontent.com/36706276/192146111-77d7c92d-defd-4cfa-9d26-7e6fb6b40f86.png)

## ❔ Usage

To quickly install this config, grab all the files in this directory and put
them in `~/.config/eww`. Then run `eww daemon` and `eww open bar`. Enjoy!

## 🎨 Theme

The theme colors can be changed in `css/_colors.scss`. Currently the theme used
is [Catppuccin Mocha](https://github.com/catppuccin/catppuccin).
