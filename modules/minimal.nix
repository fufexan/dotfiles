{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
# configuration shared by all hosts
{
  environment = {
    # set channels
    etc = {
      "nix/flake-channels/system".source = inputs.self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.hm;
    };

    systemPackages = [pkgs.git];

    # enable zsh autocompletion for system packages (systemd, etc)
    pathsToLink = ["/share/zsh"];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # saves space
    supportedLocales = ["en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" "ro_RO.UTF-8/UTF-8"];
  };

  # OpenGL
  hardware.opengl.enable = true;

  networking = {
    # required to connect to Tailscale exit nodes
    firewall.checkReversePath = "loose";

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
    };
  };

  nix = {
    buildMachines =
      #lib.filter (x: x.hostName != config.networking.hostName) [
      [
        {
          system = "aarch64-linux";
          sshUser = "root";
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          maxJobs = 4;
          hostName = "arm-server";
          supportedFeatures = ["nixos-test" "benchmark" "kvm" "big-parallel"];
        }
        {
          system = "x86_64-linux";
          sshUser = "root";
          sshKey = "/root/.ssh/id_ed25519";
          maxJobs = 8;
          hostName = "io";
          supportedFeatures = ["nixos-test" "benchmark" "kvm" "big-parallel"];
        }
      ];
    distributedBuilds = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    nixPath = [
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
      "home-manager=/etc/nix/flake-channels/home-manager"
    ];

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      substituters = [
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
        "https://fufexan.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      ];

      trusted-users = ["root" "@wheel"];
    };
  };

  nixpkgs.pkgs = inputs.self.pkgs.${config.nixpkgs.system};

  # enable programs
  programs.less.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

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

  system.stateVersion = lib.mkDefault "20.09";

  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };

  time.timeZone = lib.mkDefault "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["adbusers" "input" "libvirtd" "networkmanager" "transmission" "video" "wheel"];
  };

  zramSwap.enable = true;
}
