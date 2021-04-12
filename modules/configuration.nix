# configuration shared by all hosts
{ pkgs, config, lib, inputs, ... }:

{
  # speed fix for Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages =
    [ inputs.agenix.defaultPackage.x86_64-linux pkgs.git ];

  i18n.defaultLocale = "ro_RO.UTF-8";

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # support hardware accelerated encoding/decoding
    extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
      intel-ocl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  networking.useDHCP = false;

  nix = {
    autoOptimiseStore = true;
    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://fufexan.cachix.org"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.overlays = [
    (final: prev:
      let
        # Import nixpkgs at a specified commit
        importNixpkgsRev = { rev, sha256 }:
          import (builtins.fetchTarball {
            name = "nixpkgs-src-" + rev;
            url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
            inherit sha256;
          }) {
            inherit (config.nixpkgs) config system;
            overlays = [ ];
          };

        nixpkgs-25420cd = importNixpkgsRev {
          rev = "25420cd7876abeb4eae04912db700de79e51121b";
          sha256 = "140j5fllh8646a9cisnhhm0kmjny9ag9i0a8p783kbvlbgks0n5g";
        };
        nixpkgs-e5920f7 = importNixpkgsRev {
          rev = "e5920f73965ce9fd69c93b9518281a3e8cb77040";
          sha256 = "0kmjg80bnzc54yn17kwm0mq1n0gimvxx0i4vmh7yf7yp9hsdx6l6";
        };
      in {
        steam = nixpkgs-25420cd.steam;
        lutris = nixpkgs-25420cd.lutris;
        kakounePlugins = nixpkgs-e5920f7.kakounePlugins;
      })
  ];

  # enable programs
  programs.less.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # enable realtime capabilities to user processes
  security.rtkit.enable = true;

  # allow users in group `wheel` to use doas without prompting for password
  security.doas = {
    enable = true;
    # keep environment when running as root
    extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
      noPass = true;
    }];
  };
  # disable sudo
  security.sudo.enable = false;

  # services
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.domain = true;
    publish.userServices = true;
  };

  services.openssh = {
    enable = true;
    useDns = true;
  };

  services.tailscale.enable = true;

  services.transmission.enable = true;

  system.stateVersion = "20.09";
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "audio" "adbusers" "libvirtd" "transmission" "wheel" ];
  };
}
