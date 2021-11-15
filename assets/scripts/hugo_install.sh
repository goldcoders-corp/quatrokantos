#!/bin/bash

# set our variables
OS=""
ARCH=""
HUGO="hugo_extended"

# invoke ./hugo_install.sh -v
# pass in flag -v and -h
while getopts v:h: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
        h) HUGO=${OPTARG};;
    esac
done
# check version for comparison
function getVersion { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

if [ "$(uname)" == "Darwin" ];
then
# Do something under Mac OS X platform
    OS="macOS"
# check if using apple silicon
if [ "$(sysctl -n machdep.cpu.brand_string)" == "Apple M1" ];
then
ARCH="ARM64"
    if [ $(getVersion $version) -lt $(getVersion "0.81.0") ]; then
        ARCH="64bit"
    fi

else
ARCH="64bit"
fi
# On linux OS
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ];
    then
    # check for arch if 64 bit
    if [ "$(uname -m)" == "x86_64" ];
    then
        ARCH="64bit"
    else
        ARCH="32bit"
        # if arch is 32 bit then we wont download hugo_extended
        # only hugo will be downloaded
        HUGO="hugo"
    fi
fi

OPTPATH=~/.local/opt
# check directory
if [[ ! -d $OPTPATH ]]; then
    mkdir -pv $OPTPATH
fi

# download on tmp file directory
pushd /tmp
FOLDER="${HUGO}_v${version}"
EXECPATH=~/.local/opt/$FOLDER/bin

# create folder ~/.local/opt if not exist
if [[ ! -d $EXECPATH ]]; then
    mkdir -pv $EXECPATH
fi

# download hugo
curl -u codeitlikemiley:86a5e26161dfcb02cc725398e65cd8aa50d1d3bc -LJO "https://github.com/gohugoio/hugo/releases/download/v${version}/${HUGO}_${version}_${OS}-${ARCH}.tar.gz"


# find tarball
tarball="$(find . -name "*$OS-$ARCH.tar.gz")"
# move to folder
mv $tarball ~/.local/opt/$FOLDER
# change directory to FOLDER
pushd ~/.local/opt/$FOLDER
# extract tarball
tar -xzf $tarball

# make hugo executable
chmod +x hugo

# move to exec path
mv hugo $EXECPATH

# force update symlink if it exists
ln -sf $EXECPATH/hugo ~/.local/bin/hugo
popd

location="$(which hugo)"
echo "Hugo binary location: $location"

version="$(hugo version)"
echo "Hugo binary version: $version"