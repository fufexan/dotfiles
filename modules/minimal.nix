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
    # set channels (backwards compatibility)
    etc = {
      "nix/flake-channels/system".source = inputs.self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.hm;
    };

    # we need git for flakes
    systemPackages = [pkgs.git];

    # enable zsh autocompletion for system packages (systemd, etc)
    pathsToLink = ["/share/zsh"];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # saves space
    supportedLocales = ["en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" "ro_RO.UTF-8/UTF-8"];
  };

  # graphics drivers / HW accel
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
    # extra builders to offload work onto
    # don't set a machine as a builder to itself (throws warnings)
    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
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

    # auto garbage collect
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # set the path for channels compat
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

  # pickup pkgs from flake export
  nixpkgs.pkgs = inputs.self.pkgs.${config.nixpkgs.system};

  # enable programs
  programs.less.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting = {
      enable = true;
      patterns = {
        "rm -rf *" = "fg=white,bg=red";
      };
      styles = {
        "alias" = "fg=magenta";
      };
      highlighters = ["main" "brackets" "pattern"];
    };
  };

  # don't ask for password for wheel group
  security.sudo.wheelNeedsPassword = false;

  services = {
    # network discovery, mDNS
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

    # DNS resolver
    resolved.enable = true;

    # inter-machine VPN
    tailscale.enable = true;
  };

  # don't touch this
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
    extraGroups = ["adbusers" "input" "libvirtd" "networkmanager" "plugdev" "transmission" "video" "wheel"];
  };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
