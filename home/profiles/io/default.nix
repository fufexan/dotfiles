{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../editors/helix
    ../../editors/neovim
    ../../programs
    ../../programs/games.nix
    ../../programs/dunst.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
          }
        ];
      };
      docked-all = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "1366,0";
          }
          {
            criteria = "DP-1";
            position = "0,0";
          }
          {
            criteria = "DP-2";
            position = "1600,0";
          }
        ];
      };

      docked1 = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "1366,0";
          }
          {
            criteria = "DP-1";
            position = "0,0";
          }
        ];
      };

      docked2 = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "1366,0";
          }
          {
            criteria = "DP-2";
            position = "0,0";
          }
        ];
      };
    };
    systemdTarget = "graphical-session.target";
  };

  wayland.windowManager.hyprland.nvidiaPatches = true;
  wayland.windowManager.sway.package = inputs.self.packages.${pkgs.hostPlatform.system}.sway-hidpi;
}
