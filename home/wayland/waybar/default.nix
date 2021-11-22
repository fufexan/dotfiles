{ pkgs, config, colors, ... }:

{
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;

        output = [ "eDP-1" "DP-1" "DP-2" ];

        modules-left = [ "wlr/taskbar" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "tray" "pulseaudio" "network" "battery" ];

        modules = {
          battery = {
            format = "{capacity}% {icon}";
            format-alt = "{time} {icon}";
            format-charging = "{capacity}% ";
            format-icons = [ "" "" "" "" "" ];
            format-plugged = "{capacity}% ";
            states = {
              critical = 15;
              warning = 30;
            };
          };

          clock = {
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "{:%e %b %H:%M}";
          };

          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };

          memory = { format = "{}% "; };

          network = {
            interval = 1;
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected ⚠";
            format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
            format-linked = "{ifname} (No IP) ";
            format-wifi = "{essid} ({signalStrength}%) ";
          };

          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              handsfree = "";
              headphones = "";
              headset = "";
              phone = "";
              portable = "";
            };
            format-muted = " {format_source}";
            format-source = "";
            format-source-muted = "";
            on-click = "pavucontrol";
          };
        };
      }
    ];

    style = import ./style.nix { inherit colors; };

    systemd.enable = true;
  };
}
