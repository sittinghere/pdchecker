#!/bin/bash

workingdirectory="/var/services/homes/oliver/Scripts/"

# Get the mail recipients for the picdump notifier
source "$workingdirectory""/picdump.conf"

# Create log file if it doesn't exist yet
logfile="$workingdirectory""/pd_checker.log";
touch $logfile

# ###############################################################################
# Functions
# ###############################################################################

sendmail() {
  # Arguments: recipient address, subject, message, sender address
  /usr/bin/php -r "mail('$1','$2','$3','$4');"
}

sendmaillist() {
  # Send mails to each of the recipients in the list specified in the conf file
  # Arguments: subject, message, sender address
  for address in "${toaddress[@]}"; do
    $(sendmail "$address" "$1" "$2" "$3")
  done
}

logger() {
  DATETIME=$(date +%Y%m%d-%H:%M:%S)
  echo "PDChecker <$$> $DATETIME: $1" >> $logfile
}

# ###############################################################################
# Beginning of the script
# ###############################################################################

logger "Start"

# Get today's date
heute=$(date +%d.%m.%Y)

done=0

while [[ $done = 0 ]]; do
  # Get date and URL of latest picdump
  logger "Checking bildschirmarbeiter.com..."
  page=$(curl --silent http://www.bildschirmarbeiter.com/plugs/category/picdumps/)
  if [[ "$page" = "" ]]; then
    logger "bildschirmarbeiter.com not reached, re-trying in 30 seconds."
    sleep 30
  else
    logger "Check completed."
    regex='[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
    matches=()
    for word in "$page"; do
      [[ $word =~ $regex ]]
      if [[ ${BASH_REMATCH[0]} ]]; then
        matches+=("${BASH_REMATCH[0]}")
      fi
    done

    for match in "$matches"; do
      if [[ "$match" = "$heute" ]]; then
        letzter_dump="$heute"
      fi
    done

    url_letzter_dump="http://www.bildschirmarbeiter.com/pic/bildschirmarbeiter_-_picdump_"$letzter_dump

    # Check if the latest picdump is from today
    if [[ "$letzter_dump" = "$heute" ]]; then
      # There is a new picdump, send mail notification
      logger "Picdump is available."
      subject="Picdump"
      msg="The latest picdump is online at $url_letzter_dump"
      logger "Sending mail to recipients"
      sendmaillist "$subject" "$msg" "$fromaddress"
      done=1
    else
      # What time is it?
      hour=$(date +%H)
      if [[ "$hour" -ge "18" ]]; then
        # We stop this script at 18:00 at the latest and send out a mail that there was no picdump today.
        logger "Cutoff time reached, no picdump available today."
        subject="No Picdump"
        msg="It is now after 18:00 and the picdump notifier is shutting down. It seems there was no new picdump today."
        sendmaillist "$subject" "$msg" "$fromaddress"
        done=1
      else
        # The new picdump is not available yet, re-check in 30 seconds.
        logger "Picdump not available yet, re-checking in 30 seconds."
        sleep 30
      fi
    fi
  fi
done

logger "End"