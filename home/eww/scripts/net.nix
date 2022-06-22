pkgs: let
  nmcli = "${pkgs.networkmanager}/bin/nmcli";
  net = pkgs.writeShellScript "net" ''
    status=$(${nmcli} g | grep -oE "disconnected")
    essid=$(${nmcli} -t -f NAME connection show --active | head -n1)

    if [ $status ] ; then
      icon=""
      text=""
      color="#575268"
    else
      icon=""
      text="''${essid}"
      color="#a1bdce"
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
