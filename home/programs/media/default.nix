{ pkgs, self, ... }:
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
    crosspipe

    # audio
    amberol

    # images
    loupe

    # videos
    celluloid
    self.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell-rewrite-git

    # torrents
    transmission_4-gtk
  ];
}
