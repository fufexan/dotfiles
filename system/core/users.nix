{ pkgs, ... }:
{
  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
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
