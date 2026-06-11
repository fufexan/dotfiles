{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ./powersave.nix
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=active"
      "ideapad_laptop.allow_v4_dytc=Y"
      ''acpi_osi="Windows 2020"''
      "amdgpu.dcfeaturemask=0x8"
    ];
  };

  # nh default flake
  environment.variables.NH_FLAKE = "/home/mihai/Projects/dotfiles";

  networking.hostName = "io";

  programs.ssh.extraConfig = ''
    Host ganymede
      HostName ganymede
      User root
      IdentityFile /etc/ssh/ssh_host_ed25519_key
  '';

  security = {
    tpm2.enable = true;
    pam.services."sshd".howdy.enable = false;
  };

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
}
