pkgs: let
  programs = with pkgs; [
    bc
    gawk
    gnugrep
    procps
  ];
in
  pkgs.writeShellScript "memory" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    # human-readable
    total="$(free -h --si | grep Mem: | awk '{ print $2 }')"
    used="$(free -h --si | grep Mem: | awk '{ print $3 }')"

    # non-human-readable
    t="$(free --mega | grep Mem: | awk '{ print $2 }')"
    u="$(free --mega | grep Mem: | awk '{ print $3 }')"

    free=$(printf '%.1fG' $(bc -l <<< "($t - $u) / 1000"))

    if [[ "$1" == "total" ]]; then
        echo $total
    elif [[ "$1" == "used" ]]; then
        echo $used
    elif [[ "$1" == "free" ]]; then
        echo $free
    elif [[ "$1" == "percentage" ]]; then
        printf '%.1f' $(free -m | grep Mem | awk '{print ($3/$2)*100}')
    fi
  ''
