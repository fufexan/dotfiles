{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
    extraPackages = epkgs: [epkgs.vterm];
  };
}
