{
  config,
  colors,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;

        output = ["eDP-1" "DP-1" "DP-2"];

        modules-left = ["wlr/taskbar"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "tray" "pulseaudio" "network" "battery"];

        modules = {
          battery = {
            format = "{icon}";
            format-alt = "{power:.2} W {capacity}% {time} {icon}";
            format-charging = "{icon}󰉁";
            format-icons = ["" "" "" "" "" "" "" "" "" ""];
            format-plugged = "{capacity}%󰚥";
            interval = 2;
            states = {
              critical = 15;
              warning = 30;
            };
          };

          clock.format = "{:%e %b %H:%M}";

          cpu = {
            format = " {usage}%";
            tooltip = false;
          };

          memory.format = "󰘚 {}%";

          network = {
            interval = 1;
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected 󰀨";
            format-ethernet = "󰇧 {ifname} 󰁞 {bandwidthUpBits} 󰁆 {bandwidthDownBits}";
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            format-linked = "{ifname} (No IP) 󰀨";
            format-wifi = "{icon}";
          };

          pulseaudio = {
            format = "{icon} {volume}% {format_source}";
            format-muted = "󰖁 {format_source}";
            format-bluetooth = "{icon} {volume}% {format_source}";
            format-bluetooth-muted = "󰖁 {icon} {format_source}";
            format-icons = {
              car = "";
              default = ["󰕿" "󰖀" "󰕾"];
              hands-free = "";
              headphone = "󰋋";
              headset = "";
              phone = "󰏲";
              portable = "󰏲";
            };
            format-source = "󰍬";
            format-source-muted = "󰍭";
            on-click = "pavucontrol";
          };
        };
      }
    ];

    style = import ./style.nix colors;

    systemd = {
      enable = true;
      target =
        if config.wayland.windowManager.sway.enable
        then "sway-session.target"
        else "graphical-session.target";
    };
  };
}
