{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    scripts = [pkgs.mpvScripts.mpris];
  };
}
