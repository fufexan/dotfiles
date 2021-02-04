# NixOS Configuration

In-house baked configs for NixOS.

I'm planning on moving more of the configuration to Home Manager.

## Components

As of now, it includes configurations for:

- Fonts - configure fonts
- Neovim - manage plugins and configuration
- Pulse - Pulseaudio changes to make it realtime
- Packages - a list of packages to install and also programs with configs
- Services - manage services
- Xorg - default DM/DE/WM and keyboard config

Most of the configuration lies in `configuration.nix`.

## Install

1. Clone the repo somewhere.
2. `# NIXOS_CONFIG=<path/to/cloned/repo> nixos-rebuild <switch/install>`
3. Maybe reboot.
