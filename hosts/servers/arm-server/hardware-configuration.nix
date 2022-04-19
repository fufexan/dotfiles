{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BB6A-4956";
    fsType = "vfat";
  };
  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "xfs";
  };
}
