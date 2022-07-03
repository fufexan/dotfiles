pkgs: let
  programs = with pkgs; [
    gawk
    gnugrep
    networkmanager
  ];

  net = pkgs.writeShellScript "net" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    status=$(nmcli g | tail -n 1 | awk '{print $1}')
    signal=$(nmcli dev wifi | grep \* | awk '{ print $8 }')
    essid=$(nmcli -t -f NAME connection show --active | head -n1)

    icons=("󰤯" "󰤟" "󰤢" "󰤥" "󰤨")

    if [[ $status == "disconnected" ]] ; then
      icon=""
      text=""
      color="#988BA2"
    else
      icon=''${icons[$(awk -v n=$signal 'BEGIN{print int(n/21)}')]}
      text="''${essid}"
      color="#C9CBFF"
    fi

    if [[ "$1" == "color" ]]; then
      echo $color
    elif [[ "$1" == "essid" ]]; then
    	echo $text
    elif [[ "$1" == "icon" ]]; then
    	echo $icon
    fi
  '';
in
  net
