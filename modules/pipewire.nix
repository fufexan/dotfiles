{
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
          # Properties for the DSP configuration.
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 16;
        };
      };
      pipewire-pulse = {
        "context.modules" = {
          "libpipewire-module-protocol-pulse.args" = {
            "pulse.min.req" = "32/48000";
            "pulse.min.quantum" = "32/48000";
          };
        };
      };
    };
  };
}
