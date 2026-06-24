{ pkgs, ... }:
{
  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "i2c"
      "input"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "transmission"
      "video"
      "wheel"
    ];
  };
}
