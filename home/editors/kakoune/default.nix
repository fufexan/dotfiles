{pkgs, ...}:
# personal kakoune config
{
  programs.kakoune = {
    enable = true;
    config = {
      hooks = [
        # languages
        {
          name = "WinSetOption";
          option = "filetype=(c|cc|cpp)";
          commands = ''
            set-option buffer indentwidth 4
            set-option buffer tabstop 4
            noexpandtab
            # get extension
            declare-option str ext %sh{echo ""''${kak_bufname##*.}""}
            # filename without extension
            declare-option str noext "%sh{basename ""$kak_bufname"" .""$kak_opt_ext""}"
            # compiling
            map buffer normal <F9> %{: make %opt{noext}<ret>}
            # running
            map buffer normal <F10> %{: terminal sh -c "./%opt{noext}; read"<ret>}

            lsp-semantic-tokens
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=rust";
          commands = ''
            set-option buffer softtabstop 4
            set-option buffer tabstop 4
            set-option buffer indentwidth 4
            expandtab
          '';
        }
        # languages with 2 spaces indentation
        {
          name = "WinSetOption";
          option = "filetype=(html|javascript|json|nix|sh)";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
          '';
        }
        # languages with lsp support
        {
          name = "WinSetOption";
          option = "filetype=(c|cpp|nix)";
          commands = ''
            lsp-enable-window
            lsp-inlay-diagnostics-enable window
            hook window BufWritePre .* lsp-formatting-sync
          '';
        }
      ];
      keyMappings = [
        {
          key = "<F12>";
          mode = "normal";
          effect = "<a-|>xclip -selection clipboard<ret>";
        }
        {
          key = "l";
          mode = "user";
          effect = ": enter-user-mode lsp<ret>";
          docstring = "LSP mode";
        }
      ];
      colorScheme = "default+";
      indentWidth = 2;
      tabStop = 2;
      numberLines = {
        enable = true;
        highlightCursor = true;
      };
      scrollOff = {
        columns = 3;
        lines = 3;
      };
      showMatching = true;
      showWhitespace = {
        enable = true;
        lineFeed = "↵ ";
        nonBreakingSpace = " ";
        space = " ";
        tab = "│";
      };
      wrapLines = {
        enable = true;
        indent = true;
        word = true;
      };
    };
    extraConfig = ''
      def saveas -params 1 -file-completion %{ rename-buffer -file %arg{1}; write }
      eval %sh{
        kak-lsp --kakoune -s $kak_session
      }
    '';
    plugins = with pkgs.kakounePlugins; [
      # allows kak to talk to lsp servers
      kak-lsp
      # enables expandtab and other indent options
      #smarttab-kak # not in nixpkgs
    ];
  };

  # colorscheme
  home.file.".config/kak/colors/default+.kak".source = ./default+.kak;
  # LSP config
  home.file.".config/kak-lsp/kak-lsp.toml".source = ./kak-lsp.toml;
}
