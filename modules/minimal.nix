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

  environment.shellAliases = {
    nix-repl = "nix repl ${inputs.utils.lib.repl}";
  };

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
  # I don't currently have IPv6 so don't waste time trying to get it
  networking.dhcpcd.wait = "ipv4";

  nix = {
    autoOptimiseStore = true;
    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://fufexan.cachix.org"
      "https://osu-nix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "osu-nix.cachix.org-1:vn/szRSrx1j0IA/oqLAokr/kktKQzsDgDPQzkLFR9Cg="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
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
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "audio" "adbusers" "libvirtd" "transmission" "wheel" ];
  };

  zramSwap.enable = true;
}
