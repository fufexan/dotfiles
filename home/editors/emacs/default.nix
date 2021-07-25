{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
  };
}
