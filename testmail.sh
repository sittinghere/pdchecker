#!/bin/bash

source /var/services/homes/oliver/Scripts/picdump.conf

subject="Testmail des Picdump-Notifiers"
msg="Dies ist eine Testmail vom Picdump-Notifier, mit der der Mailversand und der Empfängerkreis getestet wird."
/usr/bin/php -r "mail('$toaddress','$subject','$msg','$fromaddress');"