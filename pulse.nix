{ configs, pkgs, ... }:

{
  # if you're an osu! player or a music producer/DJ, you definitely value low latency
  # this config sets your Pulseaudio to realtime with the best settings
  hardware.pulseaudio = {
    # assuming you already enabled pulseaudio elsewhere
    # for convenience of others that may not need this config

    # daemon.conf
    daemon.config = {
        high-priority = "yes";
        nice-level = -15;

        realtime-scheduling = "yes";
        realtime-priority = 50;

        resample-method = "speex-float-0";

        default-fragments = 2;
        # increase by 2 if your audio is distorted ↓
        default-fragment-size-msec = 4;
    };

    # default.pa
    # sets to interrupt mode instead of timed scheduling
    configFile = pkgs.runCommand "default.pa" {} ''
        sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
        ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    '';
  };

  # realtime processing for group `audio'
  security.pam.loginLimits = [
    { domain = "@audio"; item = "nice"; type = "-"; value = "-20"; }
    { domain = "@audio"; item = "rtpio"; type = "-"; value = "99"; }
  ];
}
