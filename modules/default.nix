{
  # main config, shared between hosts
  configuration = import ./configuration.nix;

  # enable flakes where this is imported
  flakes = import ./flakes.nix;

  # graphical session fonts
  fonts = import ./fonts.nix;

  # sound configuration
  # NixOS module
  pipewire = import ./pipewire.nix;
  # tdeo's version
  #pipewire-unstable = import ./pipewire-unstable.nix;

  # various services
  services = import ./services.nix;

  # low latency for usb soundcards
  snd_usb_audio = ./snd_usb_audio.nix;

  # Wayland configuration
  wayland = import ./wayland.nix;

  # X session configuration
  xorg = import ./xorg.nix;

  # if you need any of the legacy modules, include them here
  # e.g: keyboard_patching = import ./legacy/keyboard_patching.nix
}

