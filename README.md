# NixOS Configuration

In-house baked configs for Home-Manager and NixOS. Borrowed bits sprinkled on
top. Using flakes.

## Components

As of now, there are multiple modules included for:

- [Home](./home) - Home-Manager config
- Flakes - enable flakes
- Fonts - configure fonts
- PipeWire - replace Pulseaudio, JACK and ALSA
- PipeWire-unstable - tadeokondrak's replacement for the NixOS module
- Services - manage services
- Snd-usb-audio - low latency usb soundcards
- Wayland - compositors related options
- Xorg - default DM/DE/WM and keyboard config

Most of the configuration lies in `modules/configuration.nix`.

Older modules that I don't use anymore have been moved to
[modules/legacy](./modules/legacy).

## Install / Try it out

1. Clone the repo somewhere and `cd` into it.
2. `# nixos-rebuild <switch/test> --flake '.#kiiro'`. If you want a different
   hostname, change it in `flake.nix` and `hosts/<hostname>/default.nix`.
3. Maybe reboot.

## People

These are the people whom I've taken inspiration from while writing these
configs. I am thankful to all of them.

- [gytis-ivaskevicius](https://github.com/gytis-ivaskevicius)
- [DieracDelta](https://github.com/DieracDelta)
- [Nobbz](https://github.com/Nobbz)
- [hlissner](https://github.com/hlissner)
- [tadeokondrak](https://github.com/tadeokondrak)
