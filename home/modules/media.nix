{ pkgs, config, ... }:

# media - control and enjoy audio/video

{
  home.packages = with pkgs; [
    # audio control
    carla
    pavucontrol
    playerctl
    pulsemixer
    # music
    spotify
    # video
    #jellyfin-mpv-shim
  ];

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = { ncmpcpp_directory = "~/.local/share/ncmpcpp"; };
  };

  services.mpd = {
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

  services.mpdris2.enable = true;

  services.playerctld.enable = true;
}
