# configuration shared by all hosts
{ self, config, pkgs, nixpkgs, agenix, ... }@inputs:

{
  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];
  # required in order to build flakes
  environment.systemPackages = with pkgs; [ coreutils git gnutar ] ++ [
    agenix.defaultPackage.x86_64-linux
  ];

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
    #registry.nixpkgs.flake = nixpkgs;
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

  # allow proprietary packages (including drivers)
  nixpkgs.config.allowUnfree = true;

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

  system.stateVersion = "20.09";
  # allow system to auto-upgrade
  system.autoUpgrade.enable = true;

  time.timeZone = "Europe/Bucharest";

  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "libvirtd" "adbusers" ];
  };
}
