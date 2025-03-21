{pkgs, ...}:
# media - control and enjoy audio/video
{
  imports = [
    ./mpv.nix
    ./rnnoise.nix
  ];

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol
    helvum

    # audio
    amberol
    spotify

    # images
    loupe

    # videos
    celluloid

    # torrents
    transmission_4-gtk
  ];
}
