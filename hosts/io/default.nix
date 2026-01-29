{
  pkgs,
  self,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ./powersave.nix
  ];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot = {
    kernelModules = [ "i2c-dev" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=active"
      "ideapad_laptop.allow_v4_dytc=Y"
      ''acpi_osi="Windows 2020"''
      "amdgpu.dcfeaturemask=0x8"
    ];
  };

  # nh default flake
  environment.variables.NH_FLAKE = "/home/mihai/Documents/code/dotfiles";

  hardware = {
    # xpadneo.enable = true;
    sensor.iio.enable = true;
  };

  networking.hostName = "io";

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    howdy = {
      enable = true;
      control = "sufficient";
      settings = {
        core = {
          no_confirmation = true;
          abort_if_ssh = true;
        };
        video.dark_threshold = 90;
      };
    };

    linux-enable-ir-emitter.enable = true;

  };

  security.pam.services."sshd".howdy.enable = false;
}
