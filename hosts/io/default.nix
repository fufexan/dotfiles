{
  self,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
  ];

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "ideapad_laptop.allow_v4_dytc=Y"
      ''acpi_osi="Windows 2020"''
      "amdgpu.dcfeaturemask=0x8"
    ];
  };

  networking.hostName = "io";

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

  users.users =
    let
      ids = import "${self}/secrets/identities.nix";
    in
    {
      root.openssh.authorizedKeys.keys = [ ids.ganymede ];
      mihai.openssh.authorizedKeys.keys = [ ids.mihai-ganymede ];
    };
}
