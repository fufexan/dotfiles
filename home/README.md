# Nix Dotfiles

Collection of userspace programs and services managed by Home Manager on
Nix/NixOS.

This is the Nixified way of managing dotfiles. For traditional dotfiles, check
out the [legacy](https://github.com/fufexan/dotfiles/tree/legacy) branch, which
I won't be maintaining anymore. The benefit of Home Manager over standard setups
relying on stow or other tools is its ability to set up systemd services, manage
generations and more.

If you're looking for my `configuration.nix`, it's located
[here](https://github.com/fufexan/nixos-config). I keep this config separate
from the system configuration as I can install this on any Linux distro after
installing Nix on it, which makes the setup much easier.

## Install

1. Clone this repo somewhere (I keep it in `~/Documents/code/home.nix`).
2. `ln -s <path/to/repo> ~/.config/nixpkgs`
3. Follow steps 1 to 3 from
   [here](https://github.com/nix-community/home-manager#installation).
4. Enjoy 😉
