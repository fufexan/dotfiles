{ config, pkgs, ... }:

# minimal config, suitable for servers

{
  imports = [ ./modules/shell-environment.nix ];

  programs.home-manager.enable = true;
  home.username = "mihai";
  home.homeDirectory = "/home/mihai";
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    # archives
    p7zip
    unrar
    # file converters
    ffmpeg
    # file downloaders
    youtube-dl
    # file managers
    hunter
    ranger
    # nix tools
    nix-index
    # misc
    exa # ls alternative with colors & icons
    file # info about files
    glxinfo # info about OpenGL
    gotop
    htop # system monitor
    ripgrep # better grep
    tree
    usbutils
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  xdg.enable = true;

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
    enableZshIntegration = true;
    stdlib = ''
    use_flake() {
      watch_file flake.nix
      watch_file flake.lock
      eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
    }
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    changeDirWidgetOptions = [
      "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
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
    settings = { homedir = "~/.local/share/gnupg"; };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    defaultCacheTtlSsh = 300;
  };

  programs.kakoune = {
    enable = true;
    config = {
      indentWidth = 2;
      hooks = [{
        name = "InsertCompletionShow";
        option = ".*";
        commands = ''
        try %{
          # this command temporarily removes cursors preceded by whitespace;
          # if there are no cursors left, it raises an error, does not
          # continue to execute the mapping commands, and the error is eaten
          # by the `try` command so no warning appears.
          execute-keys -draft 'h<a-K>\h<ret>'
          map window insert <tab> <c-n>
          map window insert <s-tab> <c-p>
          hook -once -always window InsertCompletionHide .* %{
            map window insert <tab> <tab>
            map window insert <s-tab> <s-tab>
          }
        }
        '';
      }];
      numberLines = {
        enable = true;
        highlightCursor = true;
      };
      showMatching = true;
      tabStop = 2;
      wrapLines = {
        enable = true;
        indent = true;
        marker = "⏎";
        word = true;
      };
    };
    plugins = with pkgs.kakounePlugins; [
      kak-auto-pairs kak-fzf kak-lsp kakoune-rainbow kakoune-extra-filetypes tabs-kak
    ];
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      coc-pairs
      coc-highlight
      vim-nix
    ];
    extraConfig = builtins.readFile ./config/nvim/init.vim;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython = false;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
  };

  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "homesv.local" = {
        user = "mihai";
        identityFile = "~/.ssh/id_ed25519";
      };
      "kiiro.local" = {
        user = "mihai";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  services.lorri.enable = true;
}
