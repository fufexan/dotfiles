{ ... }:

# low-latency PipeWire configuration

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    config = {
      # pulse clients config
      pipewire-pulse = {
        "context.properties" = { };
        "context.modules" = [
          {
            name = "libpipewire-module-rtkit";
            args = {
              "nice.level" = -15;
              "rt.prio" = 88;
              "rt.time.soft" = 200000;
              "rt.time.hard" = 200000;
            };
            flags = [ "ifexists" "nofail" ];
          }
          { name = "libpipewire-module-protocol-native"; }
          { name = "libpipewire-module-client-node"; }
          { name = "libpipewire-module-adapter"; }
          { name = "libpipewire-module-metadata"; }
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              "pulse.min.req" = "32/48000";
              "pulse.min.quantum" = "32/48000";
              "pulse.min.frag" = "32/48000";
              "server.address" = [ "unix:native" ];
            };
          }
        ];

        "stream.properties" = {
          "node.latency" = "32/48000";
          "resample.quality" = 1;
        };
      };
    };
    # lower latency alsa format
    media-session.config.alsa-monitor = {
      rules = [{
        matches = [{ node.name = "alsa_output.*"; }];
        actions = {
          update-props = {
            "audio.format" = "S32LE";
            "audio.rate" = 96000;
            "api.alsa.period-size" = 32;
          };
        };
      }];
    };
  };
}
