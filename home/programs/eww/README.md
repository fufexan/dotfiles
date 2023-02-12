# Eww configuration

This configuration aims to provide a fully working shell replacement for
compositors/window managers. Features constantly get added and existing ones
get improved.

## 🗃️  Components

The same daemon runs multiple windows which interact with each other:

### bar

![bar](https://user-images.githubusercontent.com/36706276/216402839-0f8ec9b0-dc4b-4cb8-9834-db59b61db97f.png)

### music window

![music](https://user-images.githubusercontent.com/36706276/192146077-f8da4691-9a0c-487f-9805-3fd4d55551e9.gif)

### calendar

![calendar](https://user-images.githubusercontent.com/36706276/204923748-f5c7db3a-5000-40cf-ba41-cd2d5f14146a.png)

### system info

![system](https://user-images.githubusercontent.com/36706276/216403137-a3231c60-976a-4e5d-85c0-899679ab0a92.png)

## ❔ Usage

### Home Manager

If you use Home Manager, installing is as simple as adding my flake to your
inputs, passing `inputs` to `extraSpecialArgs` and importing the relevant
module:
```nix
{inputs, ...}: {
  imports = [inputs.fufexan.homeManagerModules.eww-hyprland];

  programs.eww-hyprland = {
    enable = true;

    # default package
    package = pkgs.eww-wayland;

    # if you want to change colors
    colors = builtins.readFile ./macchiato.scss;

    # set to true to reload on change
    autoReload = false; 
  };
}
```

Make sure to also add the fonts listed below.

### Other distros

To quickly install this config, grab all the files in this directory and put
them in `~/.config/eww`. Then run `eww daemon` and `eww open bar`. Enjoy!

Dependencies:
- Icon fonts: `material-symbols-outline` (any variation can be used as long as you change the `font-family` property of `.icon`)
- Text font: [Jost](https://fonts.google.com/specimen/Jost)
- Script deps: everything in `default.nix`'s `dependencies` list.

## 🎨 Theme

The theme colors can be changed in `css/_colors.scss`. Currently the theme used
is [Catppuccin Mocha](https://github.com/catppuccin/catppuccin).
