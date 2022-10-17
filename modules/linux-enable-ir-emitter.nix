{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.linux-enable-ir-emitter;
in {
  options = {
    services.linux-enable-ir-emitter = {
      enable = mkEnableOption {
        description = ''
          Linux Enable IR Emitter.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.linux-enable-ir-emitter or inputs.self.packages.${pkgs.system}.linux-enable-ir-emitter;
        defaultText = "pkgs.linux-enable-ir-emitter";
        description = ''
          Package to use for the Linux Enable IR Emitter service.
        '';
      };

      device = mkOption {
        type = types.lines;
        default = "video2";
        defaultText = "video2";
        description = ''
          Emitter device to depend on.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    powerManagement.resumeCommands = "${lib.getExe cfg.package} run";

    systemd.services.linux-enable-ir-emitter = let
      targets = [
        "multi-user.target"
        "suspend.target"
        "hybrid-sleep.target"
        "hibernate.target"
        "suspend-then-hibernate.target"
      ];
    in {
      description = "Enable the infrared emitter.";

      script = "${lib.getExe cfg.package} run";

      wantedBy = targets;
      after = targets ++ ["dev-${cfg.device}.device"];
    };
  };
}
