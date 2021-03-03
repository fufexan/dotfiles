{
  boot.kernelPatches = [
    {
      name = "snd-usb-audio_low-latency";
      patch = ./patches/linux5.11-snd-usb-audio.patch;
    }
  ];
  boot.extraModprobeConfig = ''
    options snd-usb-audio max_packs=1 max_packs_hs=1 max_urbs=12 sync_urbs=4 max_queue=18
  '';
}
