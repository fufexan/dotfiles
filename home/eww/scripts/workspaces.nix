pkgs: inputs: let
  programs = with pkgs; [
    coreutils
    findutils
    gnused
    jq
    socat
    inputs.self.packages.${pkgs.system}.hyprland
  ];

  workspaces = pkgs.writeShellScript "workspaces" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls /tmp/hypr/ | sort | tail -n 1)

    colors=("#f38ba8" "#a6e3a1" "#89b4fa" "#fab387")
    dimmed=("#794554" "#537150" "#445a7d" "#7d5943")
    export empty="#302d41"

    # set -euxo pipefail

    status() {
      if [[ ''${o[$1]} -eq 1 ]]; then
        mon=''${monitormap[''${workspaces[$1]}]}
        if [[ $focusedws -eq $1 ]]; then
          echo -n "color: ''${colors[$mon]};"
        else
          echo -n "color: ''${dimmed[$mon]};"
        fi
      else
        echo -n "color: $empty;"
      fi
    }

    workspaces() {
      declare -A o=([1]=0 [2]=0 [3]=0 [4]=0 [5]=0 [6]=0 [7]=0 [8]=0 [9]=0 [10]=0)

      monitors=$(hyprctl -j monitors)

      declare -A monitormap
      while read -r k v; do monitormap[$k]=$v; done < <(jq -r '.[]|"\(.name) \(.id) "' <<< $monitors)
      declare -A workspaces
      while read -r k v; do workspaces[$k]=$v; done < <(hyprctl -j workspaces | jq -r '.[]|"\(.id) \(.monitor)"')

      focusedws=$(jq -r '.[] | select(.active).activeWorkspace.id' <<< $monitors)

      # check if occupied
      for num in ''${!workspaces[@]}; do
        o[$num]="1"
      done

      echo -n '(eventbox :onscroll "echo {} | sed -e \"s/up/-1/g\" -e \"s/down/+1/g\" | xargs hyprctl dispatch workspace" (box :orientation "h" :class "module" :spacing 5 :space-evenly "true" '
      for i in {1..10}; do
        echo -n "(button :onclick \"hyprctl dispatch workspace $i\" :class \"ws\" :style \"$(status $i)\" \"●\") "
      done
      echo '))'
    }

    workspaces
    socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r; do
    	workspaces
    done
  '';
in
  workspaces
