{ configs, pkgs, ... }:

{
    boot.loader = {
        # installer can modify efi vars
        efi.canTouchEfiVariables = true;

        # GRUB config
        grub.enable = true;
        grub.devices = [ "/dev/disk/by-partlabel/EFI" ];
        grub.efiSupport = true;
        grub.extraConfig = "GRUB_GFXMODE=1920x1080,auto";

        # enable if you multiboot
        grub.useOSProber = true;
    };
}
