{
  inputs,
  pkgs,
  ...
}: {
  imports = [./languages.nix];

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      markdown-oxide
      nodePackages.vscode-langservers-extracted
      shellcheck
    ];

    settings = {
      theme = "onedark";
      editor = {
        color-modes = true;
        completion-trigger-len = 1;
        completion-replace = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "error";
        };
        lsp.display-inlay-hints = true;
        soft-wrap.enable = true;
        statusline.center = ["position-percentage"];
        true-color = true;
        whitespace.characters = {
          newline = "↴";
          tab = "⇥";
        };
      };

      keys = {
        normal = {
          w = "move_next_sub_word_start";
          b = "move_prev_sub_word_start";
          e = "move_next_sub_word_end";
          "A-w" = "move_next_word_start";
          "A-b" = "move_prev_word_start";
          "A-e" = "move_next_word_end";
        };
        normal.space.u = {
          f = ":format"; # format using LSP formatter
          w = ":set whitespace.render all";
          W = ":set whitespace.render none";
        };
      };
    };
  };
}
