#!/bin/bash

source /var/services/homes/oliver/Scripts/picdump.conf

subject="Testmail des Picdump-Notifiers"
msg="Dies ist eine Testmail vom Picdump-Notifier, mit der der Mailversand getestet wird. Wenn Sie diese Mail lesen, werden Sie wahrscheinlich auch zum Erscheinen des Picdumps informiert werden."
/usr/bin/php -r "mail('$toaddress','$subject','$msg','$fromaddress');"