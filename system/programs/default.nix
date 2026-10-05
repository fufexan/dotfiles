{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./gamemode.nix
    ./games.nix
    ./home-manager.nix
    ./hyprland
    ./school.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    gpu-screen-recorder.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
  ];
}
