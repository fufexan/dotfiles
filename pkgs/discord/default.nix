{ branch ? "stable", pkgs }:

let
  inherit (pkgs) callPackage fetchurl;
in
{
  stable = callPackage ./base.nix rec {
    pname = "discord-electron";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.15";
    isWayland = false;
    extraOptions = [
      "--enable-vulkan"
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
    ];
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0pn2qczim79hqk2limgh88fsn93sa8wvana74mpdk5n6x5afkvdd";
    };
  };
}.${branch}
