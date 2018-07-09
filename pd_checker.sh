#!/bin/bash

# Get the mail recipients for the picdump notifier
source /var/services/homes/oliver/Scripts/picdump.conf

# Create log file if it doesn't exist yet
logfile="/var/services/homes/oliver/Scripts/pdchecker.log";
touch $logfile

# ###############################################################################
# Functions
# ###############################################################################

strindex() {
  # Function with two arguments:
  # 1) A string
  # 2) A substring
  # Returns the index of 2) in 1)
  x="${1%%$2*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}

sendmail() {
  # Arguments: recipient address, subject, message, sender address
  /usr/bin/php -r "mail('$1','$2','$3','$4');"
}

logger(){
  DATETIME=$(date +%Y%m%d-%H:%M:%S)
  echo "PDChecker <$$> $DATETIME: $1" >> $logfile
}

# ###############################################################################
# Beginning of the script
# ###############################################################################

# Get today's date
heute=$(date +%d.%m.%Y)

done=0

while [ $done = 0 ]; do
  # Get date and URL of latest picdump
  page=$(curl --silent http://www.bildschirmarbeiter.com/plugs/category/picdumps/)
  searchstring="<p>Bildschirmarbeiter - Picdump vom "
  index=$(strindex "$page" "$searchstring")
  letzter_dump=${page:$index+36:10}
  url_letzter_dump="http://www.bildschirmarbeiter.com/pic/bildschirmarbeiter_-_picdump_"$letzter_dump
  
  # Check if the latest picdump is from today
  if [[ "$letzter_dump" = "$heute" ]]; then
    # There is a new picdump, send mail notification
    subject="Picdump"
    msg="The latest picdump is online at $url_letzter_dump"
    sendmail "$toaddress" "$subject" "$msg" "$fromaddress"
    done=1
  else
    # What time is it?
    hour=$(date +%H)
    if [ "$hour" -ge "18" ]; then
      # We stop this script at 18:00 at the latest and send out a mail that there was no picdump today.
      subject="No Picdump"
      msg="It is now after 18:00 and the picdump notifier is shutting down. It seems there was no new picdump today."
      sendmail "$toaddress" "$subject" "$msg" "$fromaddress"
      done=1
    else
      # The new picdump is not available yet, re-check in 30 seconds.
      sleep 30
    fi
  fi
done
