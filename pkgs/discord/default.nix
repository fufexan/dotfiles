{ branch ? "stable", pkgs }:

let
  inherit (pkgs) callPackage fetchurl;
in
{
  canary = callPackage ./base.nix rec {
    pname = "discord-electron-canary";
    binaryName = "DiscordCanary";
    desktopName = "Discord Canary";
    version = "0.0.130";
    isWayland = true;
    extraOptions = [
      "--enable-vulkan"
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
    ];
    src = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "sha256-UamSiwjR68Pfm3uyHaI871VaGwIKJ5DShl8uE3rvX+U=";
    };
  };
  stable = callPackage ./base.nix rec {
    pname = "discord-electron";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.16";
    isWayland = true;
    extraOptions = [
      "--enable-vulkan"
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
    ];
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-UTVKjs/i7C/m8141bXBsakQRFd/c//EmqqhKhkr1OOk=";
    };
  };
}.${branch}
