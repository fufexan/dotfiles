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
    battery_text() {
    	PERCENTAGE=`upower -d | grep percentage | awk '{ print $2 }' | head -n 1`
    	RATE=`upower -d | grep rate | awk '{ print $2 }' | head -n 1`

    	echo "$PERCENTAGE   $RATE W"
    }
    battery_remaining() {
    	TIME=`upower -d | grep time | awk '{ print $4 " " $5 }' | head -n 1`

      if [[ $TIME ]]; then
      	echo "$TIME left"
      else
        echo "fully charged"
      fi
    }

    if [[ "$1" == "bat" ]]; then
    	battery
    elif [[ "$1" == "bat-text" ]]; then
    	battery_text
    elif [[ "$1" == "bat-remaining" ]]; then
    	battery_remaining
    fi
  '';
in
  battery
