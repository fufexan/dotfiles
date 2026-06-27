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
          start = "${qs} ipc call notifications disable";
          end = "${qs} ipc call notifications disable";
        };
    };
  };
}
