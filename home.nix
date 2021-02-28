{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "mihai";
  home.homeDirectory = "/home/mihai";
  home.stateVersion = "20.09";

  # add locations to $PATH
  home.sessionPath = [ "~/.local/bin" ];
  # add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    GTK_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
  };

  # files to add to the user home
  home.file.featherfont = {
    source = ./config/fonts/feather.ttf;
    target = "${config.home.homeDirectory}/.local/share/fonts/feather.ttf";
  };
  home.file."flameshot.ini" = {
    source = ./config/flameshot.ini;
    target = "${config.home.homeDirectory}/.config/flameshot/flameshot.ini";
  };
  home.file.maim_monitor = {
    source = ./scripts/maim_monitor.sh;
    target = "${config.home.homeDirectory}/.local/bin/maim_monitor.sh";
  };
  home.file.rofiLayouts = {
    source = ./config/rofi/layouts;
    target = "${config.home.homeDirectory}/.local/share/rofi/layouts";
  };
  home.file.rofiScripts = {
    source = ./scripts/rofi;
    target = "${config.home.homeDirectory}/.local/bin/rofi";
  };

  # install user packages 
  home.packages = with pkgs; [
    # archives
    p7zip unrar
    # audio
    audacity carla pavucontrol pulsemixer
    # documents
    libreoffice
    # file converters
    ffmpeg
    # file downloaders
    youtube-dl
    # file managers
    ranger xfce.thunar
    # games
    lutris osu-lazer
    # messaging
    discord element-desktop mumble tdesktop zoom-us
    # music
    spotify
    # nix tools
    nix-index
    # torrents
    transmission-remote-gtk
    # video
    droidcam jellyfin-mpv-shim vlc

    # misc
    discord-rpc freerdp piper scrcpy
    htop gotop
    exa file glxinfo usbutils ueberzug
    gnome3.zenity xdragon
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  # accounts
  #accounts.email = {
  #  accounts.fufexan = {
  #    address = "mihai@fufexan.xyz";
  #    aliases = [ "me@fufexan.xyz" ];
  #    name = "mihai";
  #    neomutt.enable = true;
  #    notmuch.enable = true;
  #    offlineimap.enable = true;
  #  };
  #};

  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    theme.name = "Orchis-dark-compact";
    theme.package = pkgs.orchis;
  };

  # programs
  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_padding = false;
      window.padding = {
        x = 0;
        y = 0;
      };
      scrolling.history = 10000;
      font = {
        normal.family = "FiraCode Nerd Font";
        bold.family = "FiraCode Nerd Font";
        italic.family = "FiraCode Nerd Font";
        size = 11.0;
      };
      draw_bold_text_with_bright_colors = true;
      colors = {
        primary = {
          background = "0x16161c";
          foreground = "0xfdf0ed";
        };
        normal = {
          black   = "0x232530";
          red     = "0xe95678";
          green   = "0x29d398";
          yellow  = "0xfab795";
          blue    = "0x26bbd9";
          magenta = "0xee64ae";
          cyan    = "0x59e3e3";
          white   = "0xfadad1";
        };
        bright = {
          black   = "0x2e303e";
          red     = "0xec6a88";
          green   = "0x3fdaa4";
          yellow  = "0xfbc3a7";
          blue    = "0x3fc6de";
          magenta = "0xf075b7";
          cyan    = "0x6be6e6";
          white   = "0xfdf0ed";
        };
      };
      background_opacity = 0.7;
      live_config_reload = true;
    };
  };
  programs.autorandr = {
    enable = true;
    profiles.home = {
      fingerprint = {
        DVI-D-0 = "00ffffffffffff00410cafc06d37000005170103802917782abe05a156529d270c5054bd4b00818081c0010101010101010101010101662156aa51001e30468f33009ae61000001e000000ff00554b3031333035303134313839000000fc005068696c697073203139365634000000fd00384c1e530e000a20202020202000ba";
        HDMI-0  = "00ffffffffffff0009d1ea78455400000b1e010380301b782eb065a656539d280c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c4500dc0c1100001e000000ff0045334c30373535303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e5120424c323238330a200193020322f14f901f05140413031207161501061102230907078301000065030c001000023a801871382d40582c4500dc0c1100001e011d8018711c1620582c2500dc0c1100009e011d007251d01e206e285500dc0c1100001e8c0ad08a20e02d10103e9600dc0c1100001800000000000000000000000000000000000000000081";
      };
      config = {
        HDMI-0 = {
          enable   = true;
          crtc     = 1;
          gamma    = "1.099:1.0:0.909";
          mode     = "1920x1080";
          position = "0x0";
          rate     = "60.00";
          primary  = true;
        };
        DVI-D-0 = {
          enable   = true;
          crtc     = 0;
          gamma    = "1.099:1.0:0.909";
          mode     = "1366x768";
          position = "1920x312";
          rate     = "59.79";
        };
      };
      hooks.postswitch = "systemctl --user restart random-background.service";
    };
  };
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs27;
  };
  programs.feh.enable = true;
  programs.firefox = {
    enable = true;
    profiles.mihai.name = "mihai";
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    changeDirWidgetOptions = [
      "--preview 'tree -C -L 3 -a {} | head -200'"
      "--exact"
    ];
  };
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };
  programs.git = {
    enable = true;
    ignores = [ "*~" "*.swp" ];
    signing = {
      key = "3AC82B48170331D3";
      signByDefault = true;
    };
    userEmail = "fufexan@pm.me";
    userName = "Mihai Fufezan";
  };
  programs.gpg = {
    enable = true;
    settings = {
      homedir = "~/.local/share/gnupg";
    };
  };
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = {
       ncmpcpp_directory = "~/.local/share/ncmpcpp";
    };
  };
  programs.neomutt = {
    enable = false;
    checkStatsInterval = 60;
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
        vim-nix coc-nvim coc-pairs coc-prettier coc-snippets coc-highlight
        latex-live-preview vimsence
    ];
    extraConfig = builtins.readFile ./config/init.vim;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    };
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
    pass = {
      enable = true;
      extraConfig = ''
        URL_field='url';
        USERNAME_field='user';
        AUTOTYPE_field='autotype';
      '';
      stores = [ "$HOME/.local/share/password-store" ];
    };
    theme = ./config/rofi/general.rasi;
  };
  programs.texlive = {
    enable = false;
    package = pkgs.texlive.combined.scheme-basic;
  };
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-darkcolor  = "#FDF0ED";
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";
      default-fg  = "#FDF0ED";
    };
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    defaultKeymap = "viins";
    dirHashes = {
      dl = "$HOME/Downloads";
      docs = "$HOME/Documents";
      code = "$HOME/Documents/code";
    };
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
    };
    initExtra = ''
      # autoloads
      autoload -U history-search-end
      autoload -Uz vcs_info
      autoload edit-command-line

      # configure prompt
      PS1="%B%F{yellow}%n%F{green}@%F{blue}%M %F{magenta}%~ %(?.%F{green}%#.%F{red}%#)%f "

      # search history based on what's typed in the prompt
      # group functions
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      # bind functions to up and down arrow keys
      bindkey "^[[A" history-beginning-search-backward-end
      bindkey "^[[B" history-beginning-search-forward-end

      # allow editing the command in $EDITOR with ^E
      zle -N edit-command-line
      bindkey '^e' edit-command-line

      # change cursor shape for different vi modes
      function zle-keymap-select {
        if [[ $KEYMAP == vicmd ]] ||
           [[ $1 = 'block' ]]; then
          echo -ne '\e[1 q'
        elif [[ $KEYMAP == main ]] ||
             [[ $KEYMAP == viins ]] ||
             [[ $KEYMAP = '\' ]] ||
             [[ $1 = 'beam' ]]; then
          echo -ne '\e[5 q'
        fi
      }
      zle -N zle-keymap-select
      zle-line-init() {
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q' # Use beam shape cursor on startup.
      preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

      # git integration
      autoload -Uz vcs_info
      precmd_vcs_info() { vcs_info }
      precmd_functions+=( precmd_vcs_info )
      setopt prompt_subst
      RPROMPT=\$vcs_info_msg_0_
      zstyle ':vcs_info:git:*' formats '%F{blue}(%b)%r%f'
      zstyle ':vcs_info:*' enable git

      # case insensitive tab completion
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' list-colors '\'
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' verbose true
      _comp_options+=(globdots)
    '';
    shellAliases = {
      grep = "grep --color";
      ip = "ip --color";
      l = "exa -l";
      la = "exa -la";
    };
    shellGlobalAliases = {
      exa = "exa --icons --git";
    };
  };

  # services
  services.caffeine.enable = true;
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        follow = "mouse";
        geometry = "350x5-4+32";
        indicate_hidden = "yes";
        shrink = "yes";
        separator_height = 1;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 2;
        icon_position = "left";
        max_icon_size = 64;
        font = "Noto Sans 10";
        format = "<b>%s</b> | %a\n%b";
        separator_color = "auto";
        markup = "full";
        alignment = "center";
        vertical_alignment = "center";
        word_wrap = "yes";
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        show_indicators = false;
      };

      fullscreen_delay_everything = {
        fullscreen = "delay";
      };
      urgency_critical = {
        background  = "#16161c";
        foreground  = "#fdf0ed";
        frame_color = "#e95678";
      };
      urgency_low = {
        background  = "#16161c";
        foreground  = "#fdf0ed";
        frame_color = "#29d398";
      };
      urgency_normal = {
        background  = "#16161c";
        foreground  = "#fdf0ed";
        frame_color = "#fab795";
      };
    };
  };
  services.flameshot.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    defaultCacheTtlSsh = 300;
  };
  services.lorri.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      zeroconf_enabled "yes"
      zeroconf_name "MPD @ %h"
      input {
        plugin "curl"
      }
      audio_output {
        type "fifo"
        name "Visualizer"
        path "/tmp/mpd.fifo"
        format    "48000:16:2"
      }
      audio_output {
        type "pulse"
        name "PulseAudio"
      }
    '';
    network.listenAddress = "any";
    network.startWhenNeeded = true;
  };
  services.mpdris2.enable = true;
  services.picom = {
    enable = true;
    blur = true;
    blurExclude = [ "class_g = 'slop'" ];
    experimentalBackends = true;
    extraOptions = ''
      # improve performance
      glx-no-rebind-pixmap = true;

      glx-no-stencil = true;

      # fastest swap method
      glx-swap-method = 1;

      # dual kawase blur
      blur-background-fixed = false;
      blur-method = "dual_kawase";
      blur-strength = 10;

      use-ewmh-active-win = true;
      detect-rounded-corners = true;

      # stop compositing if there's a fullscreen program
      unredir-if-possible = true;

      # group wintypes and don't focus a menu (Telegram)
      detect-transient = true;
      detect-client-leader = true;

      # needed for nvidia with glx backend
      xrender-sync-fence = true;
    '';
  };
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      pulseSupport = true;
    };
    config = ./config/polybar;
    script = ''
      polybar main &
      [ $(xrandr -q | grep -w connected | grep -v primary | wc -l) -ge 1 ] && polybar external &
    '';
  };
  services.random-background = {
    enable = true;
    imageDirectory = "${config.home.homeDirectory}/Pictures/wallpapers/artworks";
  };
  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };
  services.sxhkd = {
    enable = true;
    keybindings = {
      # start terminal
      "super + Return" = "alacritty";
      # application launcher
      "super + @space" = "rofi -show combi";
      # reload sxhkd
      "super + Escape" = "pkill -USR1 -x sxhkd";
      # bspwm hotkeys
      # quit bspwm normally
      "super + alt + Escape" = "bspc quit";
      # close/kill
      "super + {_,shift + }q" = "bspc node -{c,k}";
      # monocle layout
      "super + m" = "bspc desktop -l next";
      # send the newest marked node to the newest preselected node
      "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
      # swap the current node and the biggest node
      "super + g" = "bspc node -s biggest";
      # state/flags
      # set the window state
      "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      # set the node flags
      "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";
      # focus/swap
      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      # focus the next/previous node in the current desktop
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local";
      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      # focus the last node/desktop
      "super + {grave,Tab}" = "bspc {node,desktop} -f last";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      # preselect the direction
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      # preselect the ratio
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
      # cancel the preselection for the focused node
      "super + ctrl + space" = "bspc node -p cancel";
      # cancel the preselection for the focused desktop
      "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc
      node id -p cancel";
      # move/resize
      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0
      -20,right 20 0}";
      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0
      20,bottom 0 -20,left 20 0}";
      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      # rotate window layout clockwise 90 degrees
      "super + r" = "bspc node @parent -R 90";
      # increase/decrease borders/gaps
      #"super + shift + {b,g} + {Up,Down}" = "/.config/sxhkd/bspwm_rice.sh {b,g} {+,-}";
      #	programs
      # screenshot curren monitor
      "super + Print" = "~/.local/bin/maim_monitor.sh";
      # screenshot menu
      "Print" = "~/.local/bin/rofi/screenshot.sh";
      # backlight menu
      "super + b" = "~/.local/bin/rofi/backlight.sh";
      # powermenu
      "super + p" = "~/.local/bin/rofi/powermenu.sh";
      # volume menu
      "super + v" = "~/.local/bin/rofi/volume.sh";
      # emoji launcher
      "super + e" = "rofi -show emoji";
      # rofi pass
      "super + i" = "rofi-pass";
      # music controls (mpris)
      # mpd menu
      "super + shift + m" = "~/.local/bin/rofi/mpd.sh";
      # play / pause
      "{Pause,XF86AudioPlay}" = "playerctl play-pause";
      # next/prev song
      "super + shift + {Right,Left}" = "layerctl {next,previous}";
      # toggle shuffle
      "super + alt + z" = "playerctl shuffle";
      # toggle repeat
      "super + alt + r" = "playerctl loop";
      # volume up/down
      "XF86Audio{Raise,Lower}Volume" = "pulsemixer --change-volume {+,-}5";
      # toggle mute
      "XF86AudioMute" = "pulsemixer --toggle-mute";
    };
  };
  services.syncthing.enable = true;
  services.udiskie.enable = true;
  #services.xcape = {
  #  enable = true;
  #  mapExpression = { Caps_Lock = "Escape"; };
  #  timeout = 100;
  #};

  xdg.enable = true;

  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "Capitaine Cursors";
      size = 16;
    };
    preferStatusNotifierItems = true;
    windowManager.bspwm = {
      enable = true;
      monitors = {
        HDMI-0 = [ "一" "二" "三" "四" "五" ];
        DVI-D-0 = [ "六" "七" "八" "九" "十" ];
      };
      rules = {
        "osu!.exe" = {
          desktop = "^3";
          state = "fullscreen";
        };
      };
      settings = {
        border_width = 2;
        window_gap   = 8;

        active_border_color   = "#e95678";
        focused_border_color  = "#16161c";
        normal_border_color   = "#fab795";
        presel_feedback_color = "#29d398";

        split_ratio        = 0.5;
        borderless_monocle = true;
        gapless_monocle    = true;
        single_monocle     = true;
      };
    };
  };
}
