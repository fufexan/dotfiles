#!/usr/bin/env bash

# set -ex

icons=("" "" "" "" "" "" "" "")
num_icons=$(awk -v n="${#icons[@]}" 'BEGIN{print 100 / n}')

geticon() {
  level=$(awk -v n="$percentage" -v c="$num_icons" 'BEGIN{print int(n/c-1)}')
  echo "${icons[$level]}"
}

BAT="$(upower -e | rg BAT)"

wattage() {
  echo "$info" | jaq -jr '(.energy_rate * 10.0 | round / 10.0), " ", .energy_rate_unit'
}

color() {
  [ "$percentage" -le 20 ] && echo '#f38ba8' || echo '#a6e3a1'
}

gettime() {
  if [ "$state" = "discharging" ]; then
    echo "$info" | jaq -jr '.time_to_empty, " ", .time_to_empty_unit'
  elif [ "$state" = "charging" ]; then
    echo "$info" | jaq -jr '.time_to_full, " ", .time_to_full_unit'
  fi
}

status() {
  str=""

  if [ "$state" = "fully-charged" ]; then
    str+="Fully Charged"
  else
    [ "$state" = "charging" ] && str+="charging, "
    str+="$(gettime) left"
  fi

  echo "$str"
}

gen_output() {
  info="$(upower -i "$BAT" | jc --upower | jaq '.[].detail')"
  percentage="$(echo "$info" | jaq -r '.percentage | floor')"
  state="$(echo "$info" | jaq -r '.state')"

  echo '{"icon": "'"$(geticon)"'", "percentage": '"$percentage"', "wattage": "'"$(wattage)"'", "status": "'"$(status)"'", "color": "'"$(color)"'"}'
}

gen_output
upower -m | rg --line-buffered "$BAT" | while read -r _; do
  gen_output
done
