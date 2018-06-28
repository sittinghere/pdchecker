#!/bin/bash

strindex() {
  # Function with two arguments:
  # 1) A string
  # 2) A substring
  # Returns the index of 2) in 1)
  x="${1%%$2*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

# Get today's date
heute=$(date +%d.%m.%Y)

# Get date and URL of latest picdump
page=$(curl --silent http://www.bildschirmarbeiter.com/plugs/category/picdumps/)
searchstring="<p>Bildschirmarbeiter - Picdump vom "
index=$(strindex "$page" "$searchstring")
letzter_dump=${page:$index+36:10}
url_letzter_dump="http://www.bildschirmarbeiter.com/pic/bildschirmarbeiter_-_picdump_"$letzter_dump

# Check if the latest picdump is from today
if [[ "$letzter_dump" = "$heute" ]]; then
  echo "New PICDUMP available at "$url_letzter_dump
else
  echo "No new picdump available."
fi