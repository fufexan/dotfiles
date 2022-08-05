{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # images
    imv
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };

    obs-studio.enable = true;
  };

  services = {
    easyeffects.enable = true;
    playerctld.enable = true;
  };
}
