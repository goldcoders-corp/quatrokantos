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
$HUGOCMD ="$OPTPATH\$FOLDER\hugo.exe"
$HUGOPATH = "$HOME\.local\bin\hugo"
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

# create SymbolicLink
$link = New-Item -ItemType SymbolicLink -Path $HUGOPATH -Target $HUGOCMD -Force
$link | Select-Object LinkType, Target

Push-Location $CWD