{ config, pkgs, ... }:

# personal kakoune config
#
# the only required plugin is smarttab

{
  programs.kakoune = {
    enable = true;
    config = {
      hooks = [
        {
          # tab completion
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
        }

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
        lineFeed = " ";
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
        kcr init kakoune
        kak-lsp --kakoune -s $kak_session
      }
      require-module auto-pairs
      auto-pairs-enable
    '';
    plugins = with pkgs.kakounePlugins; [
      # won't work without kakoune.cr
      auto-pairs-kak
      # allows kak to talk to lsp servers
      kak-lsp
      # enables expandtab and other indent options
      smarttab-kak
      # most plugins depend on these
      connect-kak
      prelude-kak
    ] ++ [ pkgs.kakoune-cr ];
  };

  # colorschemes
  home.file."default+" = {
    source = ./default+.kak;
    target = ".config/kak/colors/default+.kak";
  };
}
