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
    # fix build until https://github.com/NixOS/nixpkgs/pull/389740 lands in unstable
    (pwvucontrol.overrideAttrs (self: super: let
      wireplumber_0_4 = wireplumber.overrideAttrs (attrs: rec {
        version = "0.4.17";

        src = fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "pipewire";
          repo = "wireplumber";
          tag = version;
          hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
        };

        patches = [
          (fetchpatch {
            url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/f4f495ee212c46611303dec9cd18996830d7f721.patch";
            hash = "sha256-dxVlXFGyNvWKZBrZniFatPPnK+38pFGig7LGAsc6Ydc=";
          })
        ];
      });
    in {
      buildInputs = (builtins.filter (e: e.pname != "wireplumber") super.buildInputs) ++ [wireplumber_0_4];
    }))

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
