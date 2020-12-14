{ configs, pkgs, ... }:

{
  # configure zsh (not default shell)
  programs.zsh = {
    enable = true;

    # plugins
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # zsh options
    enableGlobalCompInit = true;
    setOptions = [
      "APPEND_HISTORY"
      "AUTO_CD"
      "GLOB_COMPLETE"
      "HIST_IGNORE_DUPS"
      "NO_CASE_GLOB"
    ];
    histFile = "$HOME/.cache/.histfile";
  };

  # configure console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "ro";
  };

}
