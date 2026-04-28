{ lib, pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."wireplumber.profiles".main."monitor.libcamera" = "disabled";

    # Stolen from TLATER
    extraLadspaPackages = [ pkgs.deepfilternet ];
    extraConfig.pipewire."99-input-denoising" = {
      "context.properties" = {
        "link.max-buffers" = 16;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
        "module.x11.bell" = false;
        "module.access" = true;
        "module.jackdbus-detect" = false;
      };

      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "DeepFilter Noise Canceling source";
            "media.name" = "DeepFilter Noise Canceling source";

            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "DeepFilter Mono";
                  plugin = "libdeep_filter_ladspa";
                  label = "deep_filter_mono";
                  control = {
                    "Attenuation Limit (dB)" = 100;
                  };
                }
              ];
            };

            "audio.rate" = 48000;
            "audio.position" = "[MONO]";

            "capture.props"."node.passive" = true;
            "playback.props"."media.class" = "Audio/Source";
          };
        }
      ];
    };
  };

  services.pulseaudio.enable = lib.mkForce false;
}
