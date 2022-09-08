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

    spotify-tui
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
    spotifyd = {
      enable = true;
      package = pkgs.spotifyd.override {withMpris = true;};
      settings = {
        device_type = "computer";
        use_mpris = true;
        username_cmd = "head -1 $XDG_RUNTIME_DIR/secrets/spotify";
        password_cmd = "tail -1 $XDG_RUNTIME_DIR/secrets/spotify";
      };
    };
  };
}
