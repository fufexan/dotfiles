# NixOS Configuration

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

In-house baked configs for Home-Manager and NixOS. Borrowed bits sprinkled on
top. Using [flakes](https://nixos.wiki/wiki/Flakes).

## Configurations & Modules

You can check out all this flake has to offer with
`nix flake show github:fufexan/dotfiles`!

As of now, there are multiple modules included for:

Name           | Description
-------------- | -----------
Minimal        | shared configuration
Desktop        | config aimed at desktop usage
Gamemode       | gamemode settings
Gnome          | Gnome options
Security       | tweaks for a more secure system, borrowed from [hlissner](https://github.com/hlissner/dotfiles/blob/master/modules/security.nix)

My [$HOME](./home) config managed with [Home Manager](https://github.com/nix-community/home-manager)
is also in this flake!

## People

These are the people whom I've taken inspiration from while writing these
configs. I am thankful to all of them.

- [gytis-ivaskevicius](https://github.com/gytis-ivaskevicius)
- [DieracDelta](https://github.com/DieracDelta)
- [NobbZ](https://github.com/NobbZ)
- [hlissner](https://github.com/hlissner)
- [tadeokondrak](https://github.com/tadeokondrak)
