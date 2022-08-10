pkgs: let
  programs = with pkgs; [
    gawk
    light
  ];

  brightness = pkgs.writeShellScript "brightness" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    level=$(light)

    icons=("" "" "")

    if [[ "$1" == "icon" ]]; then
      echo ''${icons[$(awk -v n=$level 'BEGIN{print int(n/34)}')]}
    elif [[ "$1" == "level" ]]; then
    	echo $level
    fi
  '';
in
  brightness
