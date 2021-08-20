{ config, pkgs, inputs, ... }:

# graphical session configuration
# includes programs and services that work on both Wayland and X

{
  imports = [
    ./cli.nix # base config
    ./terminals.nix
  ];

  home.packages = with pkgs; [
    # messaging
    (discord-plugged.override {
      plugins = [ inputs.discord-tweaks ];
      themes = [ "${inputs.discord-horizon-theme}/themes" ];
    })
    element-desktop
    tdesktop
    # torrents
    transmission-remote-gtk
    # misc
    libnotify
  ];

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Orchis-purple-dark-compact";
      package = (pkgs.orchis-theme.override { accentColor = "purple"; });
    };
  };

  programs = {
    firefox = {
      enable = true;
      profiles.mihai = { };
    };

    texlive = {
      enable = false;
      package = pkgs.texlive.combined.scheme-basic;
    };

    zathura =
      let
        c = import ./colors.nix;
      in
      {
        enable = true;
        options = {
          recolor = true;
          recolor-darkcolor = "#${c.fg}";
          recolor-lightcolor = "rgba(0,0,0,0)";
          default-bg = "rgba(0,0,0,0.7)";
          default-fg = "#${c.fg}";
        };
      };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      pinentryFlavor = "gnome3";
    };

    syncthing.enable = true;

    udiskie.enable = true;
  };
}
