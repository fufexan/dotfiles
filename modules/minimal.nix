{ pkgs, config, lib, inputs, ... }:

# configuration shared by all hosts

{
  # speed fix for Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  console.font = "Lat2-Terminus16";

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = [ pkgs.git ];

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    # saves space
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  # OpenGL
  hardware.opengl.enable = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      builders-use-substitutes = true
      experimental-features = nix-command flakes

      # for direnv GC roots
      keep-outputs = true
      keep-derivations = true
    '';

    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
      {
        system = "aarch64-linux";
        sshUser = "root";
        sshKey = "/root/.ssh/arm-server.key";
        maxJobs = 4;
        hostName = "arm-server";
        supportedFeatures = [ "nixos-test" "benchmark" "kvm" "big-parallel" ];
      }
      {
        system = "x86_64-linux";
        sshUser = "root";
        sshKey = "/root/.ssh/id_ed25519";
        maxJobs = 8;
        hostName = "io";
        supportedFeatures = [ "nixos-test" "benchmark" "kvm" "big-parallel" ];
      }
    ];
    distributedBuilds = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (n: v: { flake = v; }) inputs;

    settings = {
      auto-optimise-store = true;

      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };

  };

  nixpkgs = {
    pkgs = inputs.self.pkgs.${config.nixpkgs.system};
    config.allowUnfree = true;
  };

  # enable programs
  programs.less.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # enable realtime capabilities to user processes
  security.rtkit.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # services
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.domain = true;
      publish.userServices = true;
    };

    openssh = {
      enable = true;
      useDns = true;
    };

    resolved.enable = true;

    tailscale.enable = true;
  };

  system.stateVersion = "20.09";

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "adbusers" "networkmanager" "libvirtd" "transmission" "video" "wheel" ];
  };

  zramSwap.enable = true;
}
