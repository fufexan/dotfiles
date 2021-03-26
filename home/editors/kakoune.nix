{ pkgs, ... }:

{
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
}
