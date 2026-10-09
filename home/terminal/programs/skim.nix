{
  programs.skim = {
    enable = true;
    enableZshIntegration = true;

    # -g excludes nix build symlinks; rg only applies the global gitignore inside
    # a repo, so exclude them explicitly to cover every directory.
    # --no-messages drops the permission-denied errors rg prints for unreadable
    # dirs under ~ (wine prefixes, etc).
    defaultCommand = "rg --files --hidden --no-messages -g '!result' -g '!result-*'";
    # the Ctrl-T widget uses SKIM_CTRL_T_COMMAND, not defaultCommand; unset it
    # falls back to `find`, which ignores gitignore and lists result/.
    fileWidgetCommand = "rg --files --hidden --no-messages -g '!result' -g '!result-*'";

    # use the base16 theme (ANSI colors 0-15) so skim draws with foot's palette
    # and tracks its light/dark swap, no darkman script needed. info (the match
    # count) defaults near-white and vanishes on the light background, so pin it
    # to ANSI 8 (bright black): foot renders that dark on light, light on dark.
    defaultOptions = [ "--color=16,info:8" ];

    changeDirWidgetCommand = "fd --type d --hidden --exclude result --exclude 'result-*'";
    changeDirWidgetOptions = [
      "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
      "--exact"
    ];
  };
}
