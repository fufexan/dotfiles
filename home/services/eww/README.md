# Eww configuration

This configuration aims to provide a shell replacement for compositors/window
managers. Features constantly get added and existing ones get improved.

## 🗃️ Components

The same daemon runs multiple windows which interact with each other:

### bar

![bar](https://github.com/fufexan/dotfiles/assets/36706276/c3339908-029c-4e56-88c5-e620dc8ce00d)

### music window

![music](https://github.com/fufexan/dotfiles/assets/36706276/4260362b-8c69-417e-94c0-1436dc9febf9)

### calendar

![calendar](https://github.com/fufexan/dotfiles/assets/36706276/ddf2a40d-f758-4072-ac14-2c254cb9393a)

### system info

![system](https://github.com/fufexan/dotfiles/assets/36706276/723fd8fe-538c-41a5-bcbf-218304dc3bdf)

NOTE: Looks best with font-size set to 9pt.

## ❔ Usage

### Home Manager

If you use Home Manager, installing is as simple as adding my flake to your
inputs, passing `inputs` to `extraSpecialArgs` and importing the relevant
module:

```nix
{inputs, pkgs, ...}: {
  imports = [inputs.fufexan.homeManagerModules.eww-hyprland];

  programs.eww-hyprland = {
    enable = true;

    # default package
    package = pkgs.eww-wayland;

    # if you want to change colors
    colors = builtins.readFile ./latte.scss;

    # set to true to reload on change
    autoReload = false;
  };
}
```

Make sure to also add the fonts listed below. You can simply search where they
are in my config.

### Other distros

To quickly install this config, grab all the files in this directory and put
them in `~/.config/eww`. Then run `eww daemon` and `eww open bar`. Enjoy!

Dependencies:

- Icon fonts:
  [Material Symbols Outlined](https://github.com/google/material-design-icons/tree/master/variablefont)
  (any variation can be used as long as you change the `font-family` property of
  `.icon`)
- Text font: Inter or Roboto
- Script deps: everything in `default.nix`'s `dependencies` list.
- [gross](https://github.com/fufexan/gross)

## 🎨 Theme

The theme colors can be changed in `css/colors.scss`. There are dark/light
variants which can be symlinked to `colors.scss` to change the theme.
