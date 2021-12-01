{ pkgs, inputs, colors, ... }:

# graphical session configuration
# includes programs and services that work on both Wayland and X

{
  imports = [
    ./cli.nix # base config
    ./terminals.nix
  ];

  home.packages = with pkgs; [
    # messaging
    element-desktop
    tdesktop
    teams
    # torrents
    transmission-remote-gtk
    # misc
    libnotify
    # theming
    quintom-cursor-theme
    inputs.neovitality.defaultPackage.x86_64-linux
  ];

  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Orchis-purple-dark-compact";
      package = (pkgs.orchis-theme.override { tweaks = "primary compact"; });
    };
  };

  programs = {
    firefox = {
      enable = true;
      profiles.mihai = { };
    };

    zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-darkcolor = "#${colors.fg}";
        recolor-lightcolor = "rgba(0,0,0,0)";
        default-bg = "rgba(0,0,0,0.7)";
        default-fg = "#${colors.fg}";
      };
    };
  };

  services = {
    blueman-applet.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      pinentryFlavor = "gnome3";
    };

    network-manager-applet.enable = true;

    syncthing.enable = true;

    udiskie.enable = true;
  };
}
