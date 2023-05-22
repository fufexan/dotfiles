#!/usr/bin/env bash

get_status() {
  echo "$1" | rg -q "Playing" && echo "" || echo ""
}

get_length_sec() {
  echo "${1:-0}" | awk '{print int($1/1000000)}'
}

get_length_time() {
  echo "${len:+$(awk 'BEGIN{printf "%.0f", '"$1"' / 1000000 + 1}')}" | xargs -I{} date -d@{} +%M:%S 2>/dev/null || echo ""
}

get_position() {
  echo "${1:+$(awk 'BEGIN{printf "%.2f", '"$1"' / '"$2"' * 100}')}" | xargs printf "%.0f\n"
}

get_position_time() {
  echo "${1:+$(date -d@"$(awk 'BEGIN{printf "%.0f", '"$1"' / 1000000}')" +%M:%S)}" | xargs -I{} echo {}
}

get_cover() {
  mkdir -p "$XDG_CACHE_HOME/eww_covers"
  cd "$XDG_CACHE_HOME/eww_covers" || exit

  COVER_URL="$1"

  if [[ "$COVER_URL" = https* ]]; then
    FILENAME=$(basename "$COVER_URL")
    if [ ! -e "$FILENAME" ]; then
      wget -N "$COVER_URL" -o /dev/null
    fi

    IMG="$XDG_CACHE_HOME/eww_covers/$FILENAME"
  elif [ -n "$COVER_URL" ]; then
    IMG="$COVER_URL"
  else
    IMG=""
  fi

  echo "$IMG"
}
sanitize() {
  echo "${1//\"/\\\"}"
}

prevCover=''
prevArtist=''
prevTitle=''
prevStatus=''
prevLength=''

playerctl -F metadata -f '{{title}}\{{artist}}\{{status}}\{{position}}\{{mpris:length}}\{{mpris:artUrl}}' 2>/dev/null | while IFS="$(printf '\')" read -r title artist status position len cover; do
  if [ "$cover" != "$prevCover" ]; then
    COVER=$(get_cover "$cover")

    if [ "$COVER" != "" ]; then
      cols=$(convert "$COVER" -colors 1 -format "%c" histogram:info: | awk '{print $3}')
      border=$(echo "$cols" | head -1)

      if [ ! -e "$COVER"_bg ]; then
        brightness=$(convert "$COVER" -colorspace HSI -channel b -separate +channel -scale 1x1 -format "%[fx:100*u]\n" info:)
        if [ "${brightness%.*}" -lt 25 ]; then
          darken=false
        else
          darken=true
        fi

        convert -scale 10% -blur 0x2.5 -resize 1000% $([ "$darken" = "true" ] && echo "-brightness-contrast -30x10") "$COVER" "$COVER"_bg
      fi
      bg="url('"
      bg+="$COVER"_bg
      bg+="')"
    else
      border="#28283d"
    fi
  fi

  if [ "$prevArtist" != "$artist" ]; then
    prevArtist="$artist"
    thisArtist="$(sanitize "$artist")"
  fi

  if [ "$prevTitle" != "$title" ]; then
    prevTitle="$title"
    thisTitle="$(sanitize "$title")"
  fi

  if [ "$prevStatus" != "$status" ]; then
    prevStatus="$status"
    thisStatus="$(get_status "$status")"
  fi

  if [ "$prevLength" != "$len" ]; then
    prevLength="$len"
    thisLength="$(get_length_time "$len")"
  fi

  echo '{"artist": "'"$thisArtist"'", "title": "'"$thisTitle"'", "status": "'"$thisStatus"'", "position": "'"$(get_position "$position" "${len:-1}")"'", "position_time": "'"$(get_position_time "$position" "$len")"'", "length": "'"$thisLength"'", "cover": "'"$COVER"'", "border": "'"$border"'", "bg": "'"$bg"'"}'

  prevCover=$cover
done
