pkgs: let
  programs = with pkgs; [
    gawk
    gnugrep
    socat
  ];

  ws = pkgs.writeShellScriptBin "ws" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    activemonitor=$(hyprctl monitors | grep -B 6 "active: yes" | awk 'NR==1 {print $2}')
    passivemonitor=$(hyprctl monitors | grep  -B 2 "($1)" | awk 'NR==1 {print $2}')
    activews=$(hyprctl monitors | grep -A 2 "$activemonitor" | awk 'NR==3 {print $1}' RS='(' FS=')')
    passivews=$(hyprctl monitors | grep -A 2 "$passivemonitor" | awk 'NR==3 {print $1}' RS='(' FS=')')

    [[ $1 -eq $passivews ]] && [[ $activemonitor != "$passivemonitor" ]] && (hyprctl dispatch moveworkspacetomonitor "$activews $passivemonitor")
    hyprctl dispatch moveworkspacetomonitor "$1 $activemonitor" && hyprctl dispatch workspace "$1"
    [[ $1 -eq $passivews ]] && [[ $activemonitor != "$passivemonitor" ]] && (hyprctl dispatch focusmonitor $passivemonitor && hyprctl dispatch workspace $activews && hyprctl dispatch focusmonitor $activemonitor)

    exit 0
  '';

  workspaces = pkgs.writeShellScript "workspaces" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath (programs ++ [ws])}

    workspaces() {
    unset -v \
      o1 o2 o3 o4 o5 o6 o7 o8 o9 o10 \
      f1 f2 f3 f4 f5 f6 f7 f8 f9 f10

    # check if occupied
    for num in $(hyprctl workspaces | grep ID | awk '{print $3}'); do
      export o"$num"="$num"
    done

    #check if focused
    for num in $(hyprctl monitors | grep -B 4 "active: yes" | awk 'NR==1{print $3}'); do
      export f"$num"="$num"
    done

    echo '(eventbox :onscroll "echo {} | sed -e "s/up/-1/g" -e "s/down/+1/g" | xargs hyprctl dispatch workspace" \
            (box :class "works"	:orientation "h" :spacing 5 :space-evenly "true" \
              (button :onclick "ws 1" :class "0$o1$f1" "•") \
              (button :onclick "ws 2" :class "0$o2$f2" "•") \
              (button :onclick "ws 3" :class "0$o3$f3" "•") \
              (button :onclick "ws 4" :class "0$o4$f4" "•") \
              (button :onclick "ws 5" :class "0$o5$f5" "•") \
              (button :onclick "ws 6" :class "0$o6$f6" "•") \
              (button :onclick "ws 7" :class "0$o7$f7" "•") \
              (button :onclick "ws 8" :class "0$o8$f8" "•") \
              (button :onclick "ws 9" :class "0$o9$f9" "•") \
              (button :onclick "ws 10" :class "0$o10$f10" "•") \
            )\
          )'
    }

    workspaces
    socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r; do
    	workspaces
    done
  '';
in
  workspaces
