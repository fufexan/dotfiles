{ configs, pkgs, ... }:

{
  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [ "wheel" "audio" "libvirtd" "adbusers" ];
  };
}
