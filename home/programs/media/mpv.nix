{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
    config = {
      save-position-on-quit = true;
    };
  };
}
