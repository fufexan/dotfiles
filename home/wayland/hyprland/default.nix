{
  config,
  inputs,
  lib,
  pkgs,
  ...
} @ args: let
  apply-hm-env = pkgs.writeShellScriptBin "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != []) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
        export ${k}=${v}
      '')
      config.home.sessionVariables)}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  screenshot = import ../screenshot.nix args;
in {
  home.packages = with pkgs; [
    screenshot
    wf-recorder
    xorg.xprop
    apply-hm-env
  ];

  home.sessionVariables.XCURSOR_SIZE = builtins.toString config.home.pointerCursor.size;

  # allow swayidle to be started along with Hyprland
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["sway-session.target" "hyprland-session.target"];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.self.packages.${pkgs.system}.hyprland;
    extraConfig = import ./config.nix args;
  };
}
