{
  pkgs,
  inputs,
  config,
  ...
}:
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

  homeage = {
    isRage = true;
    identityPaths = ["~/.ssh/id_ed25519"];
    file.spotify = {
      source = "${inputs.self}/secrets/spotify.age";
      path = "spotify";
    };
  };

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
        username-cmd = "head -1 ${config.homeage.mount}/${config.homeage.file.spotify.path}";
        password-cmd = "tail -1 ${config.homeage.mount}/${config.homeage.file.spotify.path}";
      };
    };
  };
}
