pkgs: let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  curl = "${pkgs.curl}/bin/curl";
  music = pkgs.writeShellScript "music" ''
    ## Get data
    STATUS="$(${playerctl} status)"
    MUSIC_DIR="$HOME/Music"

    ## Get status
    get_status() {
    	if [[ $STATUS == "Playing" ]]; then
    		echo ""
    	else
    		echo ""
    	fi
    }

    ## Get song
    get_song() {
    	song=`${playerctl} metadata title`
    	if [[ -z "$song" ]]; then
    		echo ""
    	else
    		echo "$song"
    	fi
    }

    ## Get artist
    get_artist() {
    	artist=`${playerctl} metadata artist`
    	if [[ -z "$artist" ]]; then
    		echo ""
    	else
    		echo "$artist"
    	fi
    }

    ## Get time
    get_ctime() {
    	len=`${playerctl} metadata mpris:length`

    	if [[ -z "$len" ]]; then
    		echo "0"
    	else
    		echo "''${len::-6}"
    	fi
    }
    get_time() {
    	ctime=`${playerctl} position`
    	if [[ -z "$ctime" ]]; then
    		echo "0:00"
    	else
    		echo `${pkgs.bc}/bin/bc -l <<< "''${ctime%.*} / $(get_ctime) * 100"`
    	fi
    }

    ## Get cover
    get_cover() {
    	COVER_URL=`${playerctl} metadata mpris:artUrl`
    	STATUS=$?

    	# Check if the file has a embbeded album art
    	if [ "$STATUS" -eq 0 ]; then
        if [[ $COVER_URL = https* ]]; then
          ${curl} $COVER_URL -o /tmp/cover_art.png
          echo "/tmp/cover_art.png"
        else
      		echo "$COVER_URL"
        fi
    	else
    		echo "images/music.png"
    	fi
    }

    ## Execute accordingly
    if [[ "$1" == "song" ]]; then
    	get_song
    elif [[ "$1" == "artist" ]]; then
    	get_artist
    elif [[ "$1" == "status" ]]; then
    	get_status
    elif [[ "$1" == "time" ]]; then
    	get_time
    elif [[ "$1" == "ctime" ]]; then
    	get_ctime
    elif [[ "$1" == "cover" ]]; then
    	get_cover
    elif [[ "$1" == "toggle" ]]; then
    	${playerctl} play-pause
    elif [[ "$1" == "next" ]]; then
    	{ ${playerctl} next; get_cover; }
    elif [[ "$1" == "prev" ]]; then
    	{ ${playerctl} previous; get_cover; }
    fi
  '';
in
  music
