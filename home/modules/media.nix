{ pkgs, config, ... }:

# media - control and enjoy audio/video

{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # music
    nur.repos.milahu.spotify-adblock-linux
    # video
    #jellyfin-mpv-shim
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = [ pkgs.mpvScripts.mpris ];
    };

    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      settings = { ncmpcpp_directory = "~/.local/share/ncmpcpp"; };
    };
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Music";
      extraConfig = ''
        zeroconf_enabled "yes"
        zeroconf_name "MPD @ %h"
        input {
          plugin "curl"
        }
        audio_output {
          type "fifo"
          name "Visualizer"
          path "/tmp/mpd.fifo"
          format    "48000:16:2"
        }
        audio_output {
          type "pulse"
          name "PulseAudio"
        }
      '';
      network.listenAddress = "any";
      network.startWhenNeeded = true;
    };

    mpdris2.enable = true;

    playerctld.enable = true;

    pulseeffects = {
      enable = true;
      package = pkgs.pulseeffects-pw;
    };
  };
}
