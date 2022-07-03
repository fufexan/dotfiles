pkgs: let
  programs = with pkgs; [
    bc
    gawk
    gnugrep
    wireplumber
  ];

  volume = pkgs.writeShellScript "volume" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    volicons=("󰕿" "󰖀" "󰕾")

    vol=$(wpctl status | grep \* | head -n 1 | tail -c 6 | head -c 4 | awk '{print int($1*100)}')
    mic=$(wpctl status | grep \* | head -n 2 | tail -c 6 | head -c 4 | awk '{print int($1*100)}')

    setvol() {
      wpctl set-volume @DEFAULT_AUDIO_$1@ $(awk -v n=$2 'BEGIN{print (n / 100)}')
    }
    setmute() {
      wpctl set-mute @DEFAULT_AUDIO_$1@ toggle
    }
    getvol() {
      if [[ $1 == "SOURCE" ]]; then
        printf "%.1f" $mic
      else
        printf "%.1f" $vol
      fi
    }

    if [[ "$1" == "icon" ]]; then
    	echo ''${volicons[$(awk -v n=$vol 'BEGIN{print int(n/34)}')]}
    elif [[ $1 == "mute" ]]; then
      if [[ $2 != "SOURCE" && $2 != "SINK" ]]; then
        echo "Can only mute SINK or SOURCE"; exit 1
      fi
      setmute $2
    elif [[ $1 == "setvol" ]]; then
      if [[ $2 != "SOURCE" && $2 != "SINK" ]]; then
        echo "Can only set volume for SINK or SOURCE"; exit 1
      elif [[ $3 -lt 1 || $3 -gt 100 ]]; then
        echo "Volume must be between 1 and 100"; exit 1
      fi
      setvol $2 $3
    elif [[ $1 == "getvol" ]]; then
      getvol $2
    fi
  '';
in
  volume
