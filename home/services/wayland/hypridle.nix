{
  pkgs,
  lib,
  config,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';

  brillo = lib.getExe pkgs.brillo;
in {
  # screen idle
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      };

      listener = [
        {
          timeout = 330;
          on-timeout = suspendScript.outPath;
        }
        {
          timeout = 290;
          on-timeout = "${brillo} -u 1000000 -U 20";
          on-resume = "${brillo} -u 1000000 -A 20";
        }
      ];
    };
  };
}
