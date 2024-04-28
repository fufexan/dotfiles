{
  # keyboard remapping
  services.kanata = {
    enable = true;

    keyboards.one2mini = {
      devices = ["/dev/input/by-id/usb-Ducky_Ducky_One2_Mini_RGB_DK-V1.17-190813-event-kbd"];
      config = builtins.readFile (./. + "/main.kbd");
    };
  };
}
