{ configs, pkgs, ... }:

{
  users.users.mihai = {
    isNormalUser = true;
    shell = pkgs.zsh;

    # enable the use of sudo and Realtime Pulseaudio
    extraGroups = [ "wheel" "audio" ];
  };
}
