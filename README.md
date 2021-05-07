# NixOS Configuration

In-house baked configs for Home-Manager and NixOS. Borrowed bits sprinkled on
top. Using [flakes](https://nixos.wiki/wiki/Flakes).

The system and packages are built using
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).
Check it out!

## Configurations & Modules

You can check out all this flake has to offer with
`nix flake show github:fufexan/dotfiles`!

As of now, there are multiple modules included for:

Name           | Description
-------------- | -----------
Minimal        | configuration suited for servers
Desktop        | config aimed at desktop usage
PipeWire       | replace Pulseaudio, JACK and ALSA, configured for low latency
Security       | tweaks for a more secure system, borrowed from [hlissner](https://github.com/hlissner/dotfiles/blob/master/modules/security.nix)
Services       | server services

Older modules that I don't use anymore have been moved to
[modules/legacy](./modules/legacy).

My [home](./home) config managed with Home Manager is also in this flake!

## Apps & Packages

I have some packages available in this flake:

- [Picom (Jonaburg's fork)](https://github.com/jonaburg/picom) - rounded corners
and pretty animations!
- [Shellac-server](https://gitlab.redox-os.org/AdminXVII/shellac-server) - shell
autocompletion for Ion Shell.
- Wine Osu! - a special wine built with low latency patches to make playing osu!
a joy! (works best when paired with the PipeWire module)

## Install / Run

**NOTE**: for all further commands, if you choose not to clone the repo, you
can replace `.` with `github:fufexan/dotfiles` or set it as an environment
variable `export FD="github:fufexan/dotfiles"` and replace `.` with `$FD`.

Clone the repo somewhere and `cd` into it.

#### NixOS Configurations
```
# nixos-rebuild <switch/test> --flake .#kiiro
```
If you want a different
hostname, change it in `flake.nix` and `hosts/<hostname>/default.nix`.

#### Home Configurations
If you already have `home-manager` installed, run
```
home-manager switch --flake .#full
```
Otherwise, run
```
nix run github:nix-community/home-manager --no-write-lock-file switch --flake .#full
```

#### NixOS Modules
In order to use these modules, you'll have to add my flake to your inputs:
```nix
inputs.fufexan = {
  url = "github:fufexan/dotfiles";
  inputs.nixpkgs.follows = nixpkgs;
};
```
Then add modules to `nixosModules`:
```nix
nixosModules = [
  ...
  inputs.fufexan.nixosModules.<module>
];
```

#### Apps/Packages
Packages can be run with
`$ nix shell github:fufexan/dotfiles#<package> -c <bin_name>`.

Apps are a subset of packages and can be run with
`$ nix run github:fufexan/dotfiles#<app>`.

The packages are also available as overlays, so if you need them like that just
include `inputs.fufexan.overlays.<linux/generic>` in your `overlays`.

If you want to install packages, do:
```nix
{ inputs, ... }:

{
  environment.systemPackages = [ # can also be home.packages
    ...
    inputs.fufexan.packages.<your_arch>.<package>
    # or, if you added the overlay
    <package>
  ];
}
```

## People

These are the people whom I've taken inspiration from while writing these
configs. I am thankful to all of them.

- [gytis-ivaskevicius](https://github.com/gytis-ivaskevicius)
- [DieracDelta](https://github.com/DieracDelta)
- [NobbZ](https://github.com/NobbZ)
- [hlissner](https://github.com/hlissner)
- [tadeokondrak](https://github.com/tadeokondrak)
