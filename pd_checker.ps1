$heute = get-date -uformat "%d.%m.%Y"
$done = $false

while (-not $done){
  $result = Invoke-WebRequest "http://www.bildschirmarbeiter.com/plugs/category/picdumps/"
  $letzter_dump = $result.Content.Substring($result.Content.IndexOf("<p>Bildschirmarbeiter - Picdump vom ")+36, 10)
  $url_letzter_dump = "http://www.bildschirmarbeiter.com/pic/bildschirmarbeiter_-_picdump_" + $letzter_dump
  if ($letzter_dump.Equals($heute)){
    $outlook = New-Object -comObject  Outlook.Application
    $mail = $outlook.CreateItem(0)
    $mail.Recipients.Add("b@a.com")
    $mail.Recipients.Add("a@b.com")
    $mail.Subject = "Picdump"
    $mail.HTMLBody = "<h3><a href=" + $url_letzter_dump + ">Picdump</a> online!</h3>"
    $mail.Send()
    $done = $true
  }
  else {
    if ( (get-date).Hour -ge 18) {
      $done = $true
    }
    else {
      Start-Sleep -s 120  
    }
  }
}