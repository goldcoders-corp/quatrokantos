# ./hugo_install -version 0.89.2 -HUGO hugo
param (
    [string]$version= "",
    [string]$HUGO = "hugo_extended"
 )

$OS="Windows"
$ARCH=""
$FOLDER="${HUGO}_v${version}"
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
$URI = "https://github.com/gohugoio/hugo/releases/download/v${version}/${HUGO}_${version}_${OS}-${ARCH}.zip"

# download hugo
Invoke-WebRequest -Uri $URI -OutFile $FOLDER
# unzip hugo
Expand-Archive $TEMPDIR\$FOLDER -DestinationPath $EXECPATH

# create SymbolicLink
$link = New-Item -ItemType SymbolicLink -Path $HUGOPATH -Target $HUGOCMD -Force
$link | Select-Object LinkType, Target

Push-Location $CWD