pkgs: let
  programs = with pkgs; [
    bc
    curl
    playerctl
  ];

  music = pkgs.writeShellScript "music" ''
    export PATH=$PATH:${pkgs.lib.makeBinPath programs}

    get_status() {
      status=`playerctl status`

    	if [[ $status == "Playing" ]]; then
    		echo ""
    	else
    		echo ""
    	fi
    }

    get_title() {
    	title=`playerctl metadata title`

    	if [[ -z $title ]]; then
    		echo ""
    	else
    		echo $title
    	fi
    }

    get_artist() {
    	artist=`playerctl metadata artist`

    	if [[ -z $artist ]]; then
    		echo ""
    	else
    		echo $artist
    	fi
    }

    get_length() {
    	length=`playerctl metadata mpris:length`

    	if [[ -z $length ]]; then
    		echo 0
    	else
    		echo "''${length::-6}"
    	fi
    }
    get_length_time() {
      if [[ ! $(get_length) -eq 0 ]]; then
        echo `date -d@$(get_length) +%M:%S`
      fi
    }

    get_position() {
    	position=`playerctl position`

    	if [[ -z $position ]]; then
    		echo 0
    	else
    		echo `bc -l <<< "''${position%.*} / $(get_length) * 100"`
    	fi
    }
    get_position_time() {
      if [[ ! $(get_position) -eq 0 ]]; then
        echo `date -d@$(get_position) +%M:%S`
      fi
    }

    get_cover() {
    	COVER_URL=`playerctl metadata mpris:artUrl`
    	STATUS=$?

    	# Check if the file has a embbeded album art
    	if [ "$STATUS" -eq 0 ]; then
        if [[ $COVER_URL = https* ]]; then
          curl $COVER_URL -o /tmp/cover_art.png
          echo "/tmp/cover_art.png"
        else
      		echo "$COVER_URL"
        fi
    	else
    		echo "images/music.png"
    	fi
    }

    ## Execute accordingly
    if [[ $1 == "title" ]]; then
    	get_title
    elif [[ $1 == "artist" ]]; then
    	get_artist
    elif [[ $1 == "status" ]]; then
    	get_status
    elif [[ $1 == "length" ]]; then
    	get_length
    elif [[ $1 == "length_time" ]]; then
    	get_length_time
    elif [[ $1 == "position" ]]; then
    	get_position
    elif [[ $1 == "position_time" ]]; then
    	get_position_time
    elif [[ $1 == "cover" ]]; then
    	get_cover
    elif [[ $1 == "toggle" ]]; then
    	playerctl play-pause
    elif [[ $1 == "next" ]]; then
    	{ playerctl next; get_cover; }
    elif [[ $1 == "prev" ]]; then
    	{ playerctl previous; get_cover; }
    fi
  '';
in
  music
