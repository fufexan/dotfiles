{
  boot.kernelPatches = [
    {
      name = "snd-usb-audio-patch";
      patch = ./patches/linux591-snd-usb-audio.patch;
    }
  ];
}
