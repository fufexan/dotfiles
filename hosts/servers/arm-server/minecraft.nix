{pkgs, ...}: let
  nixpkgs-new =
    import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "195d38508ce4dfb302e815a4a3162c0883122213";
      sha256 = "sha256-Ti6fTJ+P7SqcT+DrVzsbpxyjf+cr2LLcRVRi5v0a8bE=";
    }) {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
in {
  services.minecraft-server = {
    enable = true;
    package = nixpkgs-new.minecraftServers.vanilla-1-19;
    eula = true;
    jvmOpts = "-Xms4092M -Xmx4092M
      -XX:+UseG1GC -XX:+CMSIncrementalPacing
      -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2
      -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
    openFirewall = true;
  };
}
