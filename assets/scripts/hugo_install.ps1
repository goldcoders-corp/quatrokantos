# ./hugo_install -v 0.89.2 -h hugo
param (
    [string]$v= "",
    [string]$h = "hugo_extended"
 )

$OS="Windows"
$ARCH=""
$FOLDER="${h}_v${v}"
$OPTPATH = "$HOME\.local\opt"
$EXECPATH= "$OPTPATH\$FOLDER"
$BIN="$HOME\.local\bin"
$HUGOCMD ="$OPTPATH\$FOLDER\hugo.exe"
$CWD = Get-Location
if ([Environment]::Is64BitProcess)
{
    $ARCH="64bit"
}else{
    $ARCH="32bit"
}

New-Item -ItemType Directory -Force -Path $OPTPATH
New-Item -ItemType Directory -Force -Path $EXECPATH
# cd to temporary directory
$TEMPDIR = [System.IO.Path]::GetTempPath()
Push-Location $TEMPDIR
# set uri
$URI = "https://github.com/gohugoio/hugo/releases/download/v${v}/${h}_${v}_${OS}-${ARCH}.zip"

# download hugo
Invoke-WebRequest -Uri $URI -OutFile $FOLDER
# unzip hugo
Expand-Archive $TEMPDIR\$FOLDER -DestinationPath $EXECPATH -Force

Copy-Item -Path $HUGOCMD -Destination $BIN -Force

Push-Location $CWD