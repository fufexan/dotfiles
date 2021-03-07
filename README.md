# NixOS Configuration

In-house baked configs for NixOS. Using flakes.

Home Manager config [here](https://github.com/fufexan/dotfiles).

## Components

As of now, there are multiple modules included for:

- Fonts - configure fonts
- PipeWire - replace Pulseaudio, JACK and ALSA
- Services - manage services
- Xorg - default DM/DE/WM and keyboard config

Most of the configuration lies in `modules/configuration.nix`.

Older modules that I don't use anymore have been moved to `modules/legacy`.
These include:

- Pulseaudio - tweak settings to minimize PA latency and bring it closer to
  realtime capabilities. Replaced with PipeWire.
- Neovim - configuration, replaced with a Home Manager entry.
- Keyboard Patching - patches `xkeyboard-config` and programs dependent on it
  with DreymaR's Colemak Mods or any other patch you specify. Reasons for
  deprecation in the file itself.

## Install

1. Clone the repo somewhere and `cd` into it.
2. `# nixos-rebuild switch --flake '.#nixpc'`. If you want a different
   hostname, change it in `modules/default.nix` and
   `modules/<hostname>/default.nix`.
3. Maybe reboot.
