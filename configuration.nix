{ config, pkgs, inputs, ... }:

{
  imports = [ ./modules ];
  # kernel
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];
  # make modules available to modprobe
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  # browser fix on Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

  # internationalisation
  i18n.defaultLocale = "ro_RO.UTF-8";
  # Japanese input using fcitx
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ anthy mozc ];
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # support hardware accelerated encoding/decoding
    extraPackages = with pkgs; [
      vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel libvdpau-va-gl vaapiVdpau
    ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  # network
  networking = {
    hostName = "nixpc";
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
  };
  networking.firewall.enable = false;

  nix = {
    optimise.automatic = true;
    # enable flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      flake-registry = /etc/nix/registry.json
    '';
    # pin nixpkgs to the commit the system was built from
    registry = {
      self.flake = inputs.self;
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = inputs.nixpkgs.rev;
          type = "github";
        };
      };
    };
  };

  # pipewire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
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

  services.dbus.packages = [ pkgs.gnome3.dconf ];

  system.stateVersion = "20.09";
  # allow system to auto-upgrade
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "libvirtd" "adbusers" ];
  };

  virtualisation.libvirtd.enable = true;
}
