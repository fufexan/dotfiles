{ config, pkgs, ... }:

# personal kakoune config
#
# the only required plugin is smarttab

{
  programs.kakoune = {
    enable = true;
    config = {
      indentWidth = 2;
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
          option = "filetype=nix";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
            # formatting
            set-option buffer formatcmd nixfmt
            hook buffer BufWritePre .* format
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=haskell";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
            evaluate-commands %sh{
              if which ormolu > /dev/null; then
                echo 'set-option buffer formatcmd ormolu'
                echo 'hook buffer BufWritePre .* format'
              fi
            }
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=python";
          commands = ''
            expandtab
            set-option buffer softtabstop 4
            set-option buffer tabstop 4
            set-option buffer indentwidth 4
            evaluate-commands %sh{
              if which black > /dev/null; then
                echo 'set-option buffer formatcmd "black - --quiet --fast"'
                echo 'hook buffer BufWritePre .* format'
              fi
            }
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
          option = "filetype=sh";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
            hook buffer BufWritePre .* lint
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=html";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=json";
          commands = ''
            expandtab
            set-option buffer softtabstop 2
          '';
        }
      ];
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
      # won't work without kakoune.cr
      #auto-pairs-kak
      # allows kak to talk to lsp servers
      kak-lsp
      # highlights parenthesis, brackets and braces in rainbow colours depending on depth level
      # NOTE: doesn't work for some reason
      kakoune-rainbow
      # enables expandtab and other indent options
      smarttab-kak
      # shows buffers in the statusline
      tabs-kak
      # most plugins depend on these
      connect-kak
      #kakoune.cr
      prelude-kak
    ];
  };
}
