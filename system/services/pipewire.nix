{lib, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig."wireplumber.profiles".main."monitor.libcamera" = "disabled";
  };

  hardware.pulseaudio.enable = lib.mkForce false;
}
