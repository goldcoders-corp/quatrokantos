$wshell = New-Object -ComObject wscript.shell;
Start-Sleep -milliseconds 30
$wshell.sendKeys('{ENTER}')
ntl sites:create -n $args[0]