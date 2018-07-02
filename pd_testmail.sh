#!/bin/bash

source /var/services/homes/oliver/Scripts/picdump.conf

sendmail() {
  # Arguments: recipient address, subject, message, sender address
  /usr/bin/php -r "mail('$1','$2','$3','$4');"
}

subject="Testmail des Picdump-Notifiers"
msg="Dies ist eine Testmail vom Picdump-Notifier, mit der der Mailversand getestet wird. Wenn Sie diese Mail lesen, werden Sie wahrscheinlich auch zum Erscheinen des Picdumps informiert werden."

sendmail "$toaddress" "$subject" "$msg" "$fromaddress"