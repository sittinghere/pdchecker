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
[To do]

## Alternativen
Die Datei pd_checker.ps1 enthält einen ersten Entwurf in Powershell, der evtl. nach einigen Anpassungen auf Windows-Systemen eingesetzt werden kann.

Er wurde aber nach der Portierung auf Bash nicht mehr weiterentwickelt.