{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [./hardware-configuration.nix];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];

    # load modules on boot
    kernelModules = ["acpi_call"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = ["amd_pstate=active"];
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  networking.hostName = "io";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;
    steam.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    kmonad.keyboards = {
      io = {
        name = "io";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${self}/modules/main.kbd";
      };
    };
  };
}
