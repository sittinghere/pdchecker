# PD-Checker
## Wozu dient dieses Skript?
Dieses Skript dient dazu, die Webseite www.bildschirmarbeiter.com jeden Freitag nach dem aktuellen Picdump zu durchsuchen und eine Liste von Personen per E-Mail zu benachrichtigen, wenn der neue Picdump online ist.

Ohne dieses Skript verschwendet man den ganzen Tag mit dem Warten auf den neuen Picdump und erhöht den Verschleiß seiner Tastatur durch das ständige Drücken von F5.

## Wie kann ich es installieren/benutzen?

### Technsiche Voraussetzungen
Ich lasse das Skript per Aufgabenplanung auf einem Synology-NAS laufen und nutze die darin eingerichtete Funktionalität zum Verschicken von E-Mail-Benachrichtigungen.

Diese wird durch

>/usr/bin/php -r "mail(...)"

angesteuert.

### Installation
* Das Skript muss an einem beliebigen Ort auf eurem System abgelegt werden.
* Bei Bedarf kann auch pd_testmail.sh am selben Ort abgelegt werden, um den Mailversand technisch zu testen.
* Dieses Verzeichnis wird das "Working Directory" für das Skript.

Nun müssen kleinere Anpassungen am Skript erfolgen.

Die Stelle

>workingdirectory="/var/services/homes/oliver/Scripts/"

muss angepasst werden, indem in die Variable euer "Working Directory" eingetragen wird.

Verwendet ihr ein Synology NAS, so sollte nun schon alles startklar sein.  
Wenn ihr ein anderes System einsetzt und ggf. einen anderen Mechanismus als PHP für den Mailversand einsetzen möchtet, so müsst ihr die Funktion
>sendmail() {  
>  #Arguments: recipient address, subject, message, sender address  
>  /usr/bin/php -r "mail('$1','$2','$3','$4');"  
>}

geeignet anpassen.

Schließlich müsst ihr in eurem Working Directory eine Datei names picdump.conf anlegen, die wie die Datei example.conf im Ordner ExampleConfigFile in diesem Repository aussieht. Darin werden zwei Variablen wie folgt deklariert.

>toaddress=( "recipient1@aol.com", "recipient2@gmail.com" )  
>fromaddress=$'From: a@b.com'

In dieser Konfigurationsdatei sind eure Absender-Adresse (im Fall eines Synology-NAS die Absender-Adresse eurer Synology-E-Mail-Beneachrichtigungen) und die Liste der Empfänger der Picdump-Benachrichtigung einzutragen.

## Technische Details

### Logging

Das Skript schreibt ein Logfile namens pd_checker.log in euer Working Directory.

Dies kann in eventuellen Fehlerfällen bzw. Prüfung der Funktionstüchtigkeit des Skripts nützlich sein.

Hier ist ein Auszug einer Logdatei.

>PDChecker <30337> 20180803-08:00:20: Start  
>PDChecker <30337> 20180803-08:00:20: Checking bildschirmarbeiter.com...  
>PDChecker <30337> 20180803-08:00:21: Check completed.  
>PDChecker <30337> 20180803-08:00:21: Picdump not available yet, re-checking in 30 seconds.  
>...  
>PDChecker <30337> 20180803-08:54:47: Checking bildschirmarbeiter.com...  
>PDChecker <30337> 20180803-08:54:47: Check completed.  
>PDChecker <30337> 20180803-08:54:47: Picdump not available yet, re-checking in 30 seconds.  
>PDChecker <30337> 20180803-08:55:17: Checking bildschirmarbeiter.com...  
>PDChecker <30337> 20180803-08:55:18: Check completed.  
>PDChecker <30337> 20180803-08:55:18: Picdump is available.  
>PDChecker <30337> 20180803-08:55:18: Sending mail to recipients  
>PDChecker <30337> 20180803-08:55:33: End  

Die Syntax des Logfiles lautet  
[Programmname] <[PID]> [Datums- und Zeitstempel]: [Nachricht]

### Datenschutz beim Mailversand

Das Skript schickt an jeden Empfänger in der Konfigurationsdatei eine einzelne Mail, um den Datenschutz zu wahren.

Dazu wird die Funktion

>sendmaillist()

aufgerufen, die über die Empfänger iteriert und für jedenm einzelnen Empfänger die Funktion

>sendmail()

aufruft, die dann tatsächlich den Mail-Versand anstößt.

## Alternativen
Die Datei pd_checker.ps1 enthält einen ersten Entwurf in Powershell, der evtl. nach einigen Anpassungen auf Windows-Systemen eingesetzt werden kann.

Er wurde aber nach der Portierung auf Bash nicht mehr weiterentwickelt.