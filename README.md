# NixOS Configuration

In-house baked configs for NixOS. Using flakes.

I'm planning on moving more of the configuration to Home Manager.

## Components

As of now, it includes configurations for:

- Fonts - configure fonts
- PipeWire - replace Pulseaudio, JACK and ALSA
- Packages - a list of packages to install and also programs with configs
- Services - manage services
- Xorg - default DM/DE/WM and keyboard config

Most of the configuration lies in `configuration.nix`.

Older modules that I don't use anymore have been moved to `modules/legacy`.
These include:

- Pulseaudio - tweak settings to minimize PA latency and bring it closer to
  realtime capabilities. Replaced with PipeWire.
- Neovim - configuration, replaced with a Home Manager entry.
- Keyboard Patching - patches `xkeyboard-config` and programs dependent on it
  with DreymaR's Colemak Mods or any other patch you specify. Reasonns for
  deprecation in the file itself.

## Install

1. Clone the repo somewhere and `cd` into it.
2. `# nixos-rebuild <switch/install> --flake '.#nixpc'`. If you want a different hostname, change it in `configuration.nix` and `flake.nix`.
3. Maybe reboot.
