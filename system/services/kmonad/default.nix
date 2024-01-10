{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.kmonad.nixosModules.default
  ];

  # keyboard remapping
  services.kmonad = {
    enable = true;
    package = inputs.kmonad.packages.${pkgs.system}.default;
    keyboards = {
      one2mini = {
        device = "/dev/input/by-id/usb-Ducky_Ducky_One2_Mini_RGB_DK-V1.17-190813-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile (./. + "/main.kbd");
      };
    };
  };
}
