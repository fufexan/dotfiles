{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # kernel
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    kernelModules = ["acpi_call"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # make 3.5mm jack work
    extraModprobeConfig = ''
      options snd_hda_intel model=headset-mode
    '';
  };

  hardware = {
    enableAllFirmware = true;

    opengl = {
      extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl];
      extraPackages32 = with pkgs.pkgsi686Linux; [vaapiIntel libvdpau-va-gl vaapiVdpau];
    };

    nvidia = {
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  networking.hostName = "rog";

  programs = {
    hyprland.enable = true;

    steam.enable = true;
  };

  services = {
    kmonad.keyboards = {
      rog = {
        device = "/dev/input/by-path/pci-0000:00:14.0-usb-0:8:1.0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${self}/system/services/kmonad/main.kbd";
      };
    };

    xserver.videoDrivers = ["nvidia"];
  };
}
