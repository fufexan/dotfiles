# NixOS Configuration

Following a recent transition from Void Linux to NixOS, I have baked a few
configs in this repository. The config is modular, so you can comment out
modules to fit your needs.

I'm planning on moving more of the configuration to Home Manager, which will be
integrated here.

## Components

As of now, it includes configurations for:

- Bootloader - customize the bootloader
- Fonts - configure fonts
- Neovim - manage plugins and configuration
- Network - define hostname, firewall rules, network services
- Pulse - Pulseaudio changes to make it realtime
- Packages - a list of packages to install and also programs with configs
- Services - manage services
- Shell - define the global shell and its options, and console configs
- Users - define the users and their groups
- Xorg - default DM/DE/WM and keyboard config

In the future, I will be adding more to fit my needs, or they may be moved to
home.nix.

## Installing

In order to install the config, you need to clone this repo, then symlink it to
`/etc/nixos`.

**NOTE:** Make sure to copy your hardware-configuration.nix before symlinking.
I will write a script somewhere in the near future that automates this.
