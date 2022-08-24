{pkgs, ...}: let
  programs = with pkgs; [
    gawk
    gnugrep
    networkmanager
  ];
in
  pkgs.writeShellScript "net" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    status=$(nmcli g | tail -n 1 | awk '{print $1}')
    signal=$(nmcli dev wifi | grep \* | awk '{ print $8 }')
    essid=$(nmcli -t -f NAME connection show --active | head -n1)

    icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")

    if [[ $status == "disconnected" ]] ; then
      icon=""
      text=""
      color="#988ba2"
    else
      level=$(awk -v n=$signal 'BEGIN{print int(n/20)}')
      if [[ $level -gt 4 ]]; then
        level=4
      fi

      icon=''${icons[$level]}
      text="''${essid}"
      color="#cba6f7"
    fi

    if [[ "$1" == "color" ]]; then
      echo $color
    elif [[ "$1" == "essid" ]]; then
    	echo $text
    elif [[ "$1" == "icon" ]]; then
    	echo $icon
    fi
  ''
