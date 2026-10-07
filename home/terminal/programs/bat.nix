{
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme-dark = "OneHalfDark";
      theme-light = "OneHalfLight";
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}
