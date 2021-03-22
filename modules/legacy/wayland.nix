{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    extraOptions = [ "--my-next-gpu-wont-be-nvidia" ];
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export MOZ_ENABLE_WAYLAND=1;
    '';
  };

  environment.systemPackages = [ pkgs.qt5.qtwayland ];
}
