{
  pkgs,
  lib,
  ...
}: {
  # set up nix-index
  systemd.user.timers.nix-index-db-update = {
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = 0;
    };
  };

  systemd.user.services.nix-index-db-update = {
    Unit = {
      Description = "nix-index database update";
      PartOf = ["multi-user.target"];
    };
    Service = let
      script = pkgs.writeShellScript "nix-index-update-db" ''
        export filename="index-x86_64-$(uname | tr A-Z a-z)"
        mkdir -p ~/.cache/nix-index
        cd ~/.cache/nix-index
        # -N will only download a new version if there is an update.
        wget -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename -O $filename
        ln -f $filename files
      '';
    in {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath [pkgs.wget pkgs.coreutils]}";
      ExecStart = "${script}";
    };
    Install.WantedBy = ["multi-user.target"];
  };
}
