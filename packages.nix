{ configs, pkgs, ... }:

{
  # allow the installation of unfree software.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # general utils
    htop gotop
    git gnupg pinentry
    fzf ripgrep
    file tree usbutils ueberzug
    pass
    nix-index

    # archive tools
    p7zip unzip unrar

    # audio control
    pavucontrol

    # browser
    firefox

    # C/C++ development
    gcc gdb gnumake

    # document viewers and editors
    zathura libreoffice

    # file managers
    ranger lf

    # file transfer and download
    curl rsync wget youtube-dl

    # games
    lutris steam steam-run appimage-run

    # LaTeX
    texlive.combined.scheme-basic

    # media transcoding
    ffmpeg

    # messaging
    tdesktop discord

    # mouse configuration
    piper

    # music and video
    mpd mpdris2 ncmpcpp
    mpv playerctl

    # night light
    redshift
    
    # phone sync
    kdeconnect

    # terminal emulator
    alacritty

    # themes
    capitaine-cursors kdeFrameworks.breeze-icons
    gnome-themes-extra gtk-engine-murrine
    qgnomeplatform lxappearance
    pywal
  ];

  # programs configuration
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
