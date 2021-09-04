# quatrokantos

Path
----
C:\Users\masterpowers\fvm\default\bin



# Missing DLL plugins
missing menubar_plugin.dll
window_size_plugin.dll
flutter_windows.dll
MSVCP140.dll

# this can be solve by either shipping the whole release folder with all data folder and dll files
# or install msix

- [Looping](https://fireship.io/snippets/dart-how-to-get-the-index-on-array-loop-map/)

# CWD
- each page has CWD we need to inject it on every page
- Usage for check scripts with packages.json

# Isolates
- Use this on Running NPM Scripts

# Windows Release Path
Path
----
C:\Users\masterpowers\Code\Flutter\quatrokantos\build\windows\runner\Release\quatrokantos.exe

# powershell profile used
---
${PC.userDirectory}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

Scoop failed to download must be handled
- parse this string get the command 7zip and return it
'7zip' install failed previously. Please uninstall it and try again.
- run scoop uninstall
# Adding Path
# Windows Path Shortcut CMD
// Add to Path Missing Paths in Windows
//TODO: We can use this with PathEnv (env_setter.dart)
// We need to add this step in our Wizard 1ST Step
// We will use process.run here also
```
function AddPath {
	param(
		[string]$Dir
	)
	if ( !(Test-Path $Dir) ) {
		Write-warning "Supplied directory was not found!"
		return
	}
	$PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
	if ( $PATH -notlike "*" + $Dir + "*" ) {
		[Environment]::SetEnvironmentVariable("PATH", "$PATH;$Dir", "User")
	}
}
// output each path in a new line
function list-path {
	$env:path.split(";")
}
```


Initial Path:
```
C:\Windows\system32;
C:\Windows;
C:\Windows\System32\Wbem;
C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Users\WDAGUtilityAccount\AppData\Local\Microsoft\WindowsApps;
```

Path for powershell AddPath
```
${PC.userDirectory}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```
How we can invoke powershell from cmd

```
cmd /c powershell.exe Get-Command
```


Try the following
cmd /c powershell.exe Get-Command

Execute First Command on cmd then pipe to powershell

we can try
stdin.pipe(output)


print current path
String dir = Directory.current.path;
print(dir);

Try to Inject all path we have then print it
see it on %PATH% echo on cmd

VCRUNTIME140.dll
MSVCP140.dll
VCRUNTIME140_1.dll