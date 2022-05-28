pkgs: let
  awk = "${pkgs.gawk}/bin/awk";
  rg = "${pkgs.ripgrep}/bin/rg";
  upower = "${pkgs.upower}/bin/upower";

  battery = pkgs.writeShellScript "battery" ''
    battery() {
    	PERCENTAGE=`${upower} -d | ${rg} percentage | ${awk} '{ print $2 }' | head -n 1`

    	echo "''${PERCENTAGE%\%}"
    }
    battery_text() {
    	PERCENTAGE=`${upower} -d | ${rg} percentage | ${awk} '{ print $2 }' | head -n 1`
    	RATE=`${upower} -d | ${rg} rate | ${awk} '{ print $2 }' | head -n 1`

    	echo "$PERCENTAGE   $RATE W"
    }
    battery_remaining() {
    	TIME=`${upower} -d | ${rg} time | ${awk} '{ print $4 " " $5 }' | head -n 1`

      if [ $TIME ]; then
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
