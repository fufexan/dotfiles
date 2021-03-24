{ pkgs, ... }:

let
  pipewire = pkgs.pipewire;
  pipewirei686 = pkgs.pkgsi686Linux.pipewire;
in {
  # sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    config = {
      pipewire = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 8;
        };
      };
      pipewire-pulse = {
        "context.modules".libpipewire-module-protocol-pulse.args = {
          "pulse.min.req" = "8/48000";
          "pulse.min.quantum" = "8/48000";
          "pulse.min.frag" = "8/48000";
        };
      };
    };
  };

  environment.etc."alsa/conf.d/49-pipewire-modules.conf".text = ''
    pcm_type.pipewire {
      libs {
        native ${pipewire.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so
        32Bit ${pipewirei686.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so
      }
    }
    ctl_type.pipewire {
      libs {
        native ${pipewire.lib}/lib/alsa-lib/libasound_module_ctl_pipewire.so
        32Bit ${pipewirei686.lib}/lib/alsa-lib/libasound_module_ctl_pipewire.so
      }
    }
  '';
}
