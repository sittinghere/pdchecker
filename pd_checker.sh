#!/bin/bash

# ###############################################################################
# "2021 idiot mode"
#
# Der Betreiber von bildschirmarbeiter.com scheint nicht zu wissen, wie man
# einen Kalender bedient. Mit Beginn des Jahres 2021 ist er mit seinen Kalen-
# derwochen immer eine Woche zu weit.
# Insofern: Gute Entscheidung von ihm, im vergangenen August vom genauen
# Tagesdatum zur Kalenderwoche überzugehen.
#
# Darum gibt es jetzt hier einen Parameter use_2021_idiot_mode, der dieses
# Problem behebt. Zum Jahreswechsel 2022 - oder falls der Kerl es irgendwann
# dieses Jahr doch noch schnallt - muss der Parameter wieder
# ausgeschaltet werden.
# ###############################################################################
use_2021_idiot_mode=0

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

# Get today's date (%V option for ISO week)
if [[ $use_2021_idiot_mode = 1 ]]; then
  heute="kw_"$(date -d 'next week' +%V)
  logger "++++++++++++++++++ CAUTION: 2021 IDIOT MODE ACTIVE ++++++++++++++++++"
else
  heute="kw_"$(date +%V)
fi
aktuellesjahr=$(date +%Y)

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
    regex='kw[_][0-9][0-9]'
    matches=($(echo "$page" | grep -o -s "$regex"))
    for ((i = 0; i < ${#matches[@]}; i++)); do
      match="${matches[$i]}"
      if [[ "$match" = "$heute" ]]; then
        letzter_dump="$heute"
      fi
    done

    url_letzter_dump="http://www.bildschirmarbeiter.com/pic/bildschirmarbeiter_-_picdump_"$letzter_dump"_"$aktuellesjahr

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