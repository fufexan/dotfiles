# Nix Dotfiles

Collection of userspace programs and services managed by Home Manager on
Nix/NixOS.

This is the Nixified way of managing dotfiles. For traditional dotfiles, check
out the [legacy](https://github.com/fufexan/dotfiles/tree/legacy) branch, which
I won't be maintaining anymore. The benefit of Home Manager over standard setups
relying on stow or other tools is its ability to set up systemd services, manage
generations and more.

## Install

1. Clone this repo somewhere (I keep it in `~/Documents/code/home.nix`).

	1.1. `ln -s <path/to/repo> ~/.config/nixpkgs`

2. Follow steps 1 to 3 from
   [here](https://github.com/nix-community/home-manager#installation).

3. Enjoy 😉
