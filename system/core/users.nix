{ pkgs, ... }:
{
  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "gamemode" # no-auth for gamemode's cpu/gpu polkit helpers
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
