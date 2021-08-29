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

  environment.systemPackages = [
    inputs.agenix.defaultPackage.x86_64-linux
    pkgs.git
  ];

  i18n = {
    defaultLocale = "ro_RO.UTF-8";
    # saves space
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.EUC-JP/EUC-JP"
      "ja_JP.UTF-8/UTF-8"
      "ro_RO.UTF-8/UTF-8"
    ];
  };

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
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  networking.useDHCP = false;
  # I don't currently have IPv6 so don't waste time trying to get it
  networking.dhcpcd.wait = "ipv4";

  nix = {
    autoOptimiseStore = true;

    buildMachines = [
      {
        system = "x86_64-linux";
        sshUser = "root";
        sshKey = "/root/.ssh/id_ed25519";
        maxJobs = 4;
        hostName = "kiiro";
        supportedFeatures = [ "nixos-test" "benchmark" "kvm" "big-parallel" ];
      }
    ];
    distributedBuilds = true;

    binaryCaches = [
      "https://fufexan.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    extraOptions = ''
      builders-use-substitutes = true
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    generateRegistryFromInputs = true;
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

  # allow users in group `wheel` to use doas without prompting for password
  security.doas = {
    enable = true;
    # keep environment when running as root
    extraRules = [
      {
        groups = [ "wheel" ];
        keepEnv = true;
        noPass = true;
      }
    ];
  };
  # disable sudo
  security.sudo.enable = false;

  # services
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.domain = true;
      publish.userServices = true;
    };

    # don't keep logs after reboots so boot isn't slowed down by flush
    journald.extraConfig = "Storage=volatile";

    openssh = {
      enable = true;
      useDns = true;
    };

    tailscale.enable = true;

    transmission.enable = true;
  };

  system.stateVersion = "20.09";

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "adbusers" "libvirtd" "transmission" "wheel" ];
  };

  zramSwap.enable = true;
}
