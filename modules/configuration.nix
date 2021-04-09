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

  # internationalisation
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

  # disable global DHCP
  networking.useDHCP = false;

  nix.autoOptimiseStore = true;

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
