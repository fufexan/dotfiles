{
  pkgs,
  self,
  # inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./powersave.nix
  ];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
  environment.systemPackages = [pkgs.scx];

  boot.kernelParams = [
    "amd_pstate=active"
    "ideapad_laptop.allow_v4_dytc=Y"
    ''acpi_osi="Windows 2020"''
  ];

  hardware = {
    xpadneo.enable = true;
  };

  networking.hostName = "io";

  security.tpm2.enable = true;

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    # howdy = {
    #   enable = true;
    #   package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
    #   settings = {
    #     core = {
    #       no_confirmation = true;
    #       abort_if_ssh = true;
    #     };
    #     video.dark_threshold = 90;
    #   };
    # };

    # linux-enable-ir-emitter = {
    #   enable = true;
    #   package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    # };

    kanata.keyboards.io = {
      config = builtins.readFile "${self}/system/services/kanata/main.kbd";
      devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
    };
  };
}
