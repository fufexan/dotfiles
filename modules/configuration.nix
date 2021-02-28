# configuration shared by all hosts
{ config, pkgs, inputs, ... }:

{
  imports = [ ./modules ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environments.pathsToLink = [ "/share/zsh" ];

  # internationalisation
  i18n.defaultLocale = "ro_RO.UTF-8";

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

  # disable global DHCP
  networking.useDHCP = false;

  # use flakes and flake registry
  nix = {
    autoOptimiseStore = true;
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

  # enable programs
  programs.less.enable = true;

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

  system.stateVersion = "20.09";
  # allow system to auto-upgrade
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "adbusers" ];
  };
}
