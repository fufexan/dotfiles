{
  # main config, shared between hosts
  configuration = import ./configuration.nix;

  # graphical session fonts
  fonts = import ./fonts.nix;

  # sound configuration
  #pipewire = import ./pipewire.nix;

  # various services
  services = import ./services.nix;

  # X session configuration
  xorg = import ./xorg.nix;


  # if you need any of the legacy modules, include them here
  # e.g: keyboard_patching = import ./legacy/keyboard_patching.nix
}
