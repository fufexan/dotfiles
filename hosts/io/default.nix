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
    clight.settings.sensor = let
      regression = [0.000 0.104 0.299 0.472 0.621 0.749 0.853 0.935 0.995 1.000 1.000];
    in {
      ac_regression_points = regression;
      bat_regression_points = regression;
    };

    # for SSD/NVME
    fstrim.enable = true;

    howdy = {
      enable = true;
      package = self.packages.${pkgs.system}.howdy;
      settings = {
        core.no_confirmation = true;
        video.device_path = "/dev/video2";
        video.dark_threshold = 90;
      };
    };
    linux-enable-ir-emitter.enable = true;

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
