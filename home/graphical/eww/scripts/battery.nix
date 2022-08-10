pkgs: let
  programs = with pkgs; [
    gawk
    gnugrep
    upower
  ];

  battery = pkgs.writeShellScript "battery" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    battery() {
    	PERCENTAGE=`upower -d | grep percentage | awk '{ print $2 }' | head -n 1`

    	echo "''${PERCENTAGE%\%}"
    }

    wattage() {
    	RATE=`upower -d | grep rate | awk '{ print $2 }' | head -n 1`

    	echo "$RATE W"
    }

    status() {
    	TIME=`upower -d | grep time | awk '{ print $4 " " $5 }' | head -n 1`
      STATE=`upower -d | grep state | awk '{ print $2 }' | head -n 1`

      if [[ $STATE == "charging" ]]; then
      	echo "charging, $TIME left"
      elif [[ $STATE == "discharging" ]]; then
      	echo "$TIME left"
      else
        echo "fully charged"
      fi
    }

    color() {
      if [[ $(battery) -le 20 ]]; then
        echo '#f38ba8'
      else
        echo '#a6e3a1'
      fi
    }

    if [[ "$1" == "bat" ]]; then
    	battery
    elif [[ "$1" == "wattage" ]]; then
    	wattage
    elif [[ "$1" == "status" ]]; then
    	status
    elif [[ "$1" == "color" ]]; then
    	color
    fi
  '';
in
  battery
