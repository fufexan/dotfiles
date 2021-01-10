{ configs, pkgs, ... }:

{
  boot.loader = {
    # installer can modify efi vars
    efi.canTouchEfiVariables = true;

    # GRUB config
    grub.enable = true;
    grub.device = "nodev";
    grub.efiSupport = true;
    grub.extraConfig = "GRUB_GFXMODE=1920x1080,auto";

    # enable if you multiboot
    grub.useOSProber = true;

    # systemd-boot
    #systemd-boot.enable = true;
    #systemd-boot.consoleMode = "max";
  };
}
