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
      # if you need lower min-quantum (default is 32)
      #pipewire = {
      #  "context.properties" = { "default.clock.min-quantum" = 8; };
      #};

      # pulse clients config
      pipewire-pulse = {
        "context.modules" = [
          # these have to be set for some reason (or I'm just dumb)
          { name = "libpipewire-module-protocol-native"; }
          { name = "libpipewire-module-client-node"; }
          { name = "libpipewire-module-adapter"; }
          {
            name = "libpipewire-module-metadata";
          }
          # actual lowering of latency
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              "server.address" = [ "unix:native" ];
              "pulse.min.req" = "32/48000";
              "pulse.min.quantum" = "32/48000"; # 0.67ms
              "pulse.min.frag" = "32/48000";
            };
          }
        ];
        "stream.properties" = { "node.latency" = "32/48000"; };
      };
    };
  };

  # lower latency alsa format
  environment.etc."pipewire/media-session.d/alsa-monitor.conf".text = ''
    rules = [
      {
        matches = [
          # you won't get much out of it, about ~40ms in jack_iodelay
          { node.name = "alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo" }
          # with this you'll get ~3ms
          { node.name = "alsa_output.pci-0000_00_1b.0.analog-stereo" }
        ]
        actions = {
          update-props = {
            audio.format = "S32LE"
            audio.rate = 192000
            api.alsa.period-size = 2
            #api.alsa.disable-batch = true
          }
        }
      }
    ]
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
