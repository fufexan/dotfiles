{ configs, pkgs, ... }:

{
  # allow the installation of unfree software.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # general utils
    htop gotop
    git gnupg pinentry
    fzf ripgrep
    file tree usbutils pciutils ueberzug glxinfo gnome3.zenity
    pass
    nix-index
    # archive tools
    p7zip unzip unrar
    # audio control
    pavucontrol pulsemixer
    # browser
    firefox
    # document viewers and editors
    zathura libreoffice
    # file manager
    ranger
    # file transfer and download
    curl rsync wget youtube-dl
    # games
    lutris steam steam-run
    # LaTeX
    texlive.combined.scheme-basic
    # media transcoding
    ffmpeg
    # messaging
    tdesktop discord element-desktop
    # mouse configuration
    piper
    # music and video
    mpd mpdris2 ncmpcpp
    mpv playerctl
    # night light
    redshift
    # terminal emulator
    alacritty
    # themes
    capitaine-cursors papirus-icon-theme
    lxappearance
    pywal
  ];

  # programs configuration
  programs.adb.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.less.enable = true;
  programs.steam.enable = true;
  programs.zsh = {
    enable = true;
    # plugins
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      autoload -U promptinit && promptinit && prompt walters && setopt prompt_sp
      PS1="%B%F{yellow}%n%F{green}@%F{blue}%M %F{magenta}%~ %(?.%F{green}%#.%F{red}%#)%f "
    '';
    # options
    setOptions = [
      "AUTO_CD"
      "GLOB_COMPLETE"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_REDUCE_BLANKS"
      "INC_APPEND_HISTORY"
      "NO_CASE_GLOB"
    ];
    shellAliases = {
      grep = "grep --color";
      l = "ls -lhAL";
      md = "mkdir -p";
    };
    histFile = "$HOME/.cache/.histfile";
  };
}
