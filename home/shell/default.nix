{ config, ... }:

{
  imports = [
    #./starship.nix
    ./zsh.nix
  ];

  # add locations to $PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.local/bin/rofi"
  ];
  # add environment variables
  home.sessionVariables = {
    EDITOR = "kak";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    # make java apps work in tiling WMs
    _JAVA_AWT_WM_NONREPARENTING = 1;
    # make apps aware of fcitx
    GTK_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
  };
}
