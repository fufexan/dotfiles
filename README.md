<h1 align="center">fufexan/dotfiles</h1>

# 🗒 About

In-house baked configs for Home-Manager and NixOS. Borrowed bits sprinkled on
top. Using [flakes](https://nixos.wiki/wiki/Flakes).

See an overview of the flake outputs by running
`nix flake show github:fufexan/dotfiles`.

## 🗃️  Contents

- [modules](modules): NixOS common configs
- [hosts](hosts): host-specific configuration
- [home](home): my [Home-Manager](https://github.com/nix-community/home-manager) config
- [lib](lib): helper functions
- [pkgs](pkgs): package definitions

# 📦 Exported packages

Run packages directly with:

```console
nix run github:fufexan/dotfiles#packageName
```

Or install from the `packages` output. For example:

```nix
# flake.nix
{
  inputs.fufexan-dotfiles.url = "github:fufexan/dotfiles";
  # Override my nixpkgs, binary cache will have less hits
  inputs.fufexan-dotfiles.inputs.nixpkgs.follows = "nixpkgs";
}

# configuration.nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.fufexan-dotfiles.packages."x86_64-linux".packageName
  ];
}
```

## 💻 Desktop preview

<a href="https://drive.google.com/file/d/1W-bwn3UwbMxReiiNqMmq38noa7Xw0Gj1/preview">
  <img src="https://user-images.githubusercontent.com/36706276/192147190-cf9cf4df-94cb-4a3b-b9d8-137ed0c2538f.png" alt="Desktop Preview">
</a>
*Hint: click to go to a video showcase*

# 💾 Resources

Other configurations from where I learned and copied:

- [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus)
- [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles)
- [viperML/dotfiles](https://github.com/viperML/dotfiles)
- [privatevoid-net/privatevoid-infrastructure](https://github.com/privatevoid-net/privatevoid-infrastructure)
- [Mic92/dotfiles](https://github.com/Mic92/dotfiles)
- [colemickens/nixcfg](https://github.com/colemickens/nixcfg)
- [NobbZ/nixos-config](https://github.com/NobbZ/nixos-config)

# 👥 People

These are the people whom I've taken inspiration from while writing these
configs. There surely are more but I tend to forget. Regardless, I am thankful
to all of them.

gytis-ivaskevicius - DieracDelta - NobbZ - hlissner - tadeokondrak - viperML -
max-privatevoid - pnotequalnp - Xe - keksbg - Misterio77 - OPNA2608 -
yusdacra - matthewcroughan - Kranzes
