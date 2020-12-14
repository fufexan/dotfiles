{ configs, pkgs, ... }:

{
  # allow the installation of unfree software.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # general utils
    gotop git gnupg nodejs fzf ripgrep tree usbutils pass

    # archive tools
    p7zip unzip unrar

    # terminal emulators
    alacritty

    # editors
    neovim

    # file manager
    ranger

    # browsers
    firefox

    # night light
    redshift

    # themes
    capitaine-cursors kdeFrameworks.breeze-icons

    # music and media
    mpd mpdris2 ncmpcpp mpv youtube-dl playerctl mps-youtube ffmpeg pavucontrol

    # file transfer
    syncthing curl wget rsync

    # Wayland
    #hikari grim slurp waybar wl-clipboard
  ];

  # programs configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # enable configuration of gaming mice
  services.ratbagd.enable = true;
}
