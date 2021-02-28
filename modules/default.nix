{
  imports = [
    # main config, shared between hosts
    ./configuration.nix

    # graphical session fonts
    ./fonts.nix

    # sound configuration
    #./pipewire.nix

    # various services
    ./services.nix

    # X session configuration
    ./xorg.nix


    # if you need any of the legacy modules, include them here
    # e.g: ./legacy/keyboard_patching.nix
  ];
}
