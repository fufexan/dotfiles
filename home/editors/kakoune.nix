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
            noexpandtab
            set-option buffer indentwidth 4
            set-option buffer tabstop 4
            set-option buffer softtabstop 4
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
          option = "filetype=nix";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
            # formatting
            set-option buffer formatcmd 'nixpkgs-fmt'
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=javascript";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
            evaluate-commands %sh{
              if which prettier > /dev/null; then
                echo 'set-option buffer formatcmd "prettier --parser=typescript"'
                echo 'hook buffer BufWritePre .* format'
              fi
            }
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=rust";
          commands = ''
            set-option buffer softtabstop 4
            set-option buffer tabstop 4
            set-option buffer indentwidth 4
            evaluate-commands %sh{
              if which rustfmt > /dev/null; then
                echo 'set-option buffer formatcmd rustfmt'
                echo 'hook buffer BufWritePre .* format'
              fi
            }
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=(sh|html|json)";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
          '';
        }
      ];
      keyMappings = [{
        key = "<F12>";
        mode = "normal";
        effect = "<a-|>xclip -selection clipboard<ret>";
      }];
      colorScheme = "desertex";
      indentWidth = 2;
      tabStop = 2;
      numberLines = {
        enable = true;
        highlightCursor = true;
      };
      showMatching = true;
      wrapLines = {
        enable = true;
        indent = true;
        marker = "⏎";
        word = true;
      };
    };
    extraConfig = ''
      def saveas -params 1 -file-completion %{ rename-buffer -file %arg{1}; write }
    '';
    plugins = with pkgs.kakounePlugins; [
      # won't work without kakoune.cr
      #auto-pairs-kak
      # allows kak to talk to lsp servers
      kak-lsp
      # enables expandtab and other indent options
      smarttab-kak
      # most plugins depend on these
      connect-kak
      #kakoune.cr
      prelude-kak
    ];
  };
}
