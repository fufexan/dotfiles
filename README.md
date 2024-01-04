<h1 align="center">fufexan/dotfiles</h1>

# 🗒 About

In-house baked configs for Home-Manager and NixOS. Borrowed bits sprinkled on
top. Using [flakes](https://nixos.wiki/wiki/Flakes) and
[flake-parts](https://github.com/hercules-ci/flake-parts).

See an overview of the flake outputs by running
`nix flake show github:fufexan/dotfiles`.

## 🗃️ Contents

- [modules](modules): NixOS common configs
- [hosts](hosts): host-specific configuration
- [home](home): my [Home Manager](https://github.com/nix-community/home-manager)
  config
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
  inputs.fufexan-dotfiles = {
    url = "github:fufexan/dotfiles";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}

# configuration.nix
{pkgs, inputs, ...}: {
  environment.systemPackages = [
    inputs.fufexan-dotfiles.packages."x86_64-linux".packageName
  ];
}
```

## 💻 Desktop preview

Currently, my widgets are created using [Ags](https://github.com/Aylur/ags/). If
you're looking for the [Eww](https://github.com/elkowar/eww) version, you can
find it [here](https://github.com/fufexan/dotfiles/tree/eww).

<details>
<summary>
Dark
</summary>
<a href="https://drive.google.com/file/d/1W-bwn3UwbMxReiiNqMmq38noa7Xw0Gj1/preview">
  <img src="https://github.com/fufexan/dotfiles/assets/36706276/d0cc86c8-39b1-4a49-b9d9-6f161f2420f2" alt="Desktop Preview Dark">
</a>
*Hint: click to go to a video showcase*
</details>
<details>
<summary>
Light
</summary>
<img src="https://github.com/fufexan/dotfiles/assets/36706276/badef73f-b45a-45a2-b1d6-fe615d5f89b2" alt="Desktop Preview Light">
</details>

<details>
<summary>
Previous versions
</summary>
  <img src="https://user-images.githubusercontent.com/36706276/216402032-ff32fcad-ca21-49d3-9c29-6ff0d2d8b1d8.png" alt="Desktop Preview">
  <img src="https://user-images.githubusercontent.com/36706276/236707086-ea6cb781-8b0c-45d3-b6a1-2c6a4d5e2582.png" alt="Desktop Preview">
</details>

# 💾 Resources

Other configurations from where I learned and copied:

- [colemickens/nixcfg](https://github.com/colemickens/nixcfg)
- [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus)
- [gytis-ivaskevicius/nixfiles](https://github.com/gytis-ivaskevicius/nixfiles)
- [Mic92/dotfiles](https://github.com/Mic92/dotfiles)
- [NobbZ/nixos-config](https://github.com/NobbZ/nixos-config)
- [privatevoid-net/privatevoid-infrastructure](https://github.com/privatevoid-net/privatevoid-infrastructure)
- [RicArch97/nixos-config](https://github.com/RicArch97/nixos-config)
- [viperML/dotfiles](https://github.com/viperML/dotfiles)

# 👥 People

These are the people whom I've taken inspiration from while writing these
configs. There surely are more but I tend to forget. Regardless, I am thankful
to all of them.

DieracDelta - gytis-ivaskevicius - hlissner - keksbg - Kranzes -
matthewcroughan - max-privatevoid - Misterio77 - NobbZ - OPNA2608 -
pnotequalnp - RicArch97 - tadeokondrak - viperML - Xe - yusdacra
