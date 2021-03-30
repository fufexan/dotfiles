{ config, pkgs, ... }:

# low-latency PipeWire configuration

let
  pipewire = pkgs.pipewire;
  pipewirei686 = pkgs.pkgsi686Linux.pipewire;
in {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    config = {
      # if you need lower min-quantum
      pipewire = {
        "context.properties" = { "default.clock.min-quantum" = 8; };
      };

      # pulse clients config
      pipewire-pulse = {
        "context.modules" = [
          # these have to be set for some reason (or I'm just dumb)
          { name = "libpipewire-module-protocol-native"; }
          { name = "libpipewire-module-client-node"; }
          { name = "libpipewire-module-adapter"; }
          { name = "libpipewire-module-metadata"; }
          # actual lowering of latency
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              "server.address" = [ "unix:native" ];
              "pulse.min.req" = "8/48000";
              "pulse.min.quantum" = "8/48000";
              "pulse.min.frag" = "8/48000";
            };
          }
        ];
        "stream.properties" = {
          "node.latency" = "8/48000";
        };
      };
    };
  };

  # lower latency alsa format
  environment.etc."pipewire/media-session.d/alsa-monitor.conf".text = ''
    rules = [
      {
        matches = [{ node.name = ~alsa_output.*?-LOUD.* }]
        actions = {
          update-props = {
            audio.format = "S16LE"
            audio.rate = 48000
            api.alsa.period-size = 160
          }
        }
      }
    ]
  '';

  # add pipewire as an alsa device
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

  # enable higher rtprio for the audio group
  # TODO: change to rtkit or something
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
  ];

  # allow the audio group to write to rtc0 and hpet
  services.udev.extraRules = ''
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
  '';

  # increase kernel timer. useful for snappier system
  # causes fewer underruns for low sample size applications
  systemd.services.kernelTimer = {
    enable = true;
    description = "Increase timer resolution";
    script = ''
        #!/bin/sh
        echo 2048 | tee /sys/class/rtc/rtc0/max_user_freq /proc/sys/dev/hpet/max-user-freq
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
