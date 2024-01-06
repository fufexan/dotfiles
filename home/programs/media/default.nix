{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./rnnoise.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    pulsemixer

    # audio
    amberol

    # images
    loupe

    # videos
    celluloid
  ];
}
