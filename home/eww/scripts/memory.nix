pkgs: let
  programs = with pkgs; [
    bc
    gawk
    gnugrep
    procps
  ];

  memory = pkgs.writeShellScript "memory" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    # human-readable
    total="$(free -h --si | grep Mem: | awk '{ print $2 }')"
    used="$(free -h --si | grep Mem: | awk '{ print $3 }')"

    # non-human-readable
    t="$(free --mega | grep Mem: | awk '{ print $2 }')"
    u="$(free --mega | grep Mem: | awk '{ print $3 }')"

    free=$(printf '%.1f\n' $(bc -l <<< "($t - $u) / 1000"))

    if [[ "$1" == "total" ]]; then
        echo printf '%.1f' $total
    elif [[ "$1" == "used" ]]; then
        echo printf '%.1f' $used
    elif [[ "$1" == "free" ]]; then
        echo printf '%.1f' $free
    elif [[ "$1" == "percentage" ]]; then
        printf '%.1f' $(free -m | grep Mem | awk '{print ($3/$2)*100}')
    fi
  '';
in
  memory
