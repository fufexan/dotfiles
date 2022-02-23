colors:

let
  inherit (colors) xcolors rgbaColors;

  style = ''
    * {
      border: none;
      border-radius: 0;
      /* `otf-font-awesome` is required to be installed for icons */
      font-family: Roboto, Helvetica, Arial, sans-serif;
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background-color: ${rgbaColors.base00};
      color: ${xcolors.base06};
      transition-property: background-color;
      transition-duration: .5s;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    /*
    window#waybar.empty {
      background-color: transparent;
    }
    window#waybar.solo {
      background-color: ${xcolors.base06};
    }
    */

    #workspaces button {
      padding: 0 5px;
      background-color: transparent;
      color: ${xcolors.base06};
      /* Use box-shadow instead of border so the text isn't offset */
      box-shadow: inset 0 -3px transparent;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    #workspaces button:hover {
      background: rgba(0, 0, 0, 0.2);
      box-shadow: inset 0 -3px ${xcolors.base06};
    }

    #workspaces button.focused {
      background-color: #64727D;
      box-shadow: inset 0 -3px ${xcolors.base06};
    }

    #workspaces button.urgent {
      background-color: #eb4d4b;
    }

    #mode {
      background-color: #64727D;
      border-bottom: 3px solid ${xcolors.base06};
    }

    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #mpd {
      padding: 0 10px;
      color: ${xcolors.base00};
    }

    #window,
    #workspaces {
      margin: 0 4px;
    }

    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces {
      margin-left: 0;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
      margin-right: 0;
    }

    #clock {
      background-color: #64727D;
      color: ${xcolors.base06};
    }

    #battery {
      background-color: ${xcolors.base06};
      color: ${xcolors.base00};
    }

    #battery.charging, #battery.plugged {
      color: ${xcolors.base06};
      background-color: #26A65B;
    }

    @keyframes blink {
      to {
          background-color: ${xcolors.base06};
          color: ${xcolors.base00};
      }
    }

    #battery.critical:not(.charging) {
      background-color: ${xcolors.base08};
      color: ${xcolors.base06};
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    label:focus {
      background-color: ${xcolors.base06};
    }

    #cpu {
      background-color: ${xcolors.base0B};
    }

    #memory {
      background-color: ${xcolors.base0E};
    }

    #disk {
      background-color: #964B00;
    }

    #backlight {
      background-color: ${xcolors.base0A};
    }

    #network {
      background-color: ${xcolors.base0D};
    }

    #network.disconnected {
      background-color: ${xcolors.base08};
    }

    #pulseaudio {
      background-color: ${xcolors.base0A};
    }

    #pulseaudio.muted {
      background-color: ${rgbaColors.base0A};
      color: #2a5c45;
    }

    #custom-media {
      background-color: #66cc99;
      color: #2a5c45;
      min-width: 100px;
    }

    #custom-media.custom-spotify {
      background-color: #66cc99;
    }

    #custom-media.custom-vlc {
      background-color: #ffa000;
    }

    #temperature {
      background-color: #f0932b;
    }

    #temperature.critical {
      background-color: #eb4d4b;
    }

    #tray {
      background-color: ${xcolors.base0C};
      color: ${xcolors.base00};
    }

    #tray > .passive {
      -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
      background-color: #eb4d4b;
    }

    #idle_inhibitor {
      background-color: #2d3436;
    }

    #idle_inhibitor.activated {
      background-color: #ecf0f1;
      color: #2d3436;
    }

    #mpd {
      background-color: #66cc99;
      color: #2a5c45;
    }

    #mpd.disconnected {
      background-color: #f53c3c;
    }

    #mpd.stopped {
      background-color: #90b1b1;
    }

    #mpd.paused {
      background-color: #51a37a;
    }

    #language {
      background: #00b093;
      color: #740864;
      padding: 0 5px;
      margin: 0 5px;
      min-width: 16px;
    }

    #keyboard-state {
      background: #97e1ad;
      color: ${xcolors.base06};
      padding: 0 0px;
      margin: 0 5px;
      min-width: 16px;
    }

    #keyboard-state > label {
      padding: 0 5px;
    }

    #keyboard-state > label.locked {
      background: rgba(0, 0, 0, 0.2);
    }
  '';
in
style
