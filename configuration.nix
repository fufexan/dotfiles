{ config, pkgs, ... }:

{
  imports =
    [
      # the default for the machine
      /etc/nixos/hardware-configuration.nix

      # fonts
      ./fonts.nix

      # neovim configuration
      ./neovim.nix

      # in case you want low latency on your Pulseaudio setup
      # mostly applicable to producers and osu! players
      # NOTE: not needed anymore if you use PipeWire
      ./pulse.nix

      # packages to install system-wide
      ./packages.nix
      
      # service configration
      ./services.nix

      # in case you use Xorg
      ./xorg.nix
    ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];
  # make modules available to modprobe
  boot.extraModulePackages = [ pkgs.linuxPackages_zen.v4l2loopback ];
  # browser fix on Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
  };

  boot.tmpOnTmpfs = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

  # internationalisation
  i18n.defaultLocale = "ro_RO.UTF-8";
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = [ pkgs.ibus-engines.anthy ];
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

  nix.optimise.automatic = true;

  # enable sound throuth PipeWire
  #services.pipewire = {
  #  enable = true;
  #  socketActivation = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  jack.enable = true;
  #  pulse.enable = true;
  #};

  programs.zsh = {
    enable = true;

    # plugins
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # options
    enableGlobalCompInit = true;
    setOptions = [
      "AUTO_CD"
      "GLOB_COMPLETE"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_REDUCE_BLANKS"
      "INC_APPEND_HISTORY"
      "NO_CASE_GLOB"
    ];
    histFile = "$HOME/.cache/.histfile";
  };

  # enable realtime capabilities to user processes
  security.rtkit.enable = true;

  # allow users in group `wheel` to use doas without prompting for password
  security.doas = {
    enable = true;
    wheelNeedsPassword = false;
    # keep environment when running as root
    extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
    }];
  };
  # disable sudo
  security.sudo.enable = false;

  system.stateVersion = "20.09";
  # allow system to auto-upgrade
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "libvirtd" "adbusers" ];
  };

  virtualisation.libvirtd.enable = true;
}
