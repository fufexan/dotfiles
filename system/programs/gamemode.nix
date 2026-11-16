{ pkgs, ... }: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom =
        let
          qs = "${pkgs.quickshell}/bin/qs";
        in
        {
          start = "${qs} ipc -p $HOME/.config/quickshell/notifd.qml call notifications disable";
          end = "${qs} ipc -p $HOME/.config/quickshell/notifd.qml call notifications disable";
        };
    };
  };
}
