# NixOS Configuration

In-house baked configs for Home-Manager and NixOS. Borrowed bits sprinkled on
top. Using flakes.

The system is built using
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).
Check it out!

## Components

You can check out all this flake has to offer with
`nix flake show github:fufexan/dotfiles`!

### System

As of now, there are multiple modules included for:

- [Home](./home) - Home-Manager config
- Minimal - configuration suited for servers
- Desktop - config aimed at desktop usage
- PipeWire - replace Pulseaudio, JACK and ALSA, configured for low latency
- Security - tweaks for a more secure system, borrowed from
[hlissner](https://github.com/hlissner/dotfiles/blob/master/modules/security.nix)
- Services - server services

Older modules that I don't use anymore have been moved to
[modules/legacy](./modules/legacy).

#### Installing / Trying it out

1. Clone the repo somewhere and `cd` into it.
2. `# nixos-rebuild <switch/test> --flake '.#kiiro'`. If you want a different
hostname, change it in `flake.nix` and `hosts/<hostname>/default.nix`.
3. Maybe reboot.

### Apps & Packages

I have some packages available in this flake:

- [Hunter](https://github.com/rabite0/hunter) - the fastest file manager in the
galaxy!
- [Picom (Jonaburg's fork)](https://github.com/jonaburg/picom) - rounded corners
and pretty animations!
- [Shellac-server](https://gitlab.redox-os.org/AdminXVII/shellac-server) - shell
autocompletion for Ion Shell.
- Wine Osu! - a special wine built with low latency patches to make playing osu!
a joy! (works best when paired with the PipeWire module)

#### Running

These packages can be run with
`$ nix shell github:fufexan/dotfiles#<package> -c <bin_name>`.

Apps can be run with `$ nix run github:fufexan/dotfiles#<app>`. For now only
hunter is available as an app, but in the future I may add others as well.

#### Installing

In order to install the above, you'll have to add my flake to your inputs:
```nix
inputs.fufexan.url = "github:fufexan/dotfiles";
```
The next step is adding my packages, for example like this:
```nix
environment.systemPackages = [
  ...
  inputs.fufexan.packages.<your_arch>.<package>
];
```

The packages are also available as overlays, so if you need them like that just
include `inputs.fufexan.overlays.<linux/generic>` in your `overlays`.

## People

These are the people whom I've taken inspiration from while writing these
configs. I am thankful to all of them.

- [gytis-ivaskevicius](https://github.com/gytis-ivaskevicius)
- [DieracDelta](https://github.com/DieracDelta)
- [NobbZ](https://github.com/NobbZ)
- [hlissner](https://github.com/hlissner)
- [tadeokondrak](https://github.com/tadeokondrak)
