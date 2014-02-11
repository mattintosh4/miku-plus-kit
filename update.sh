#!/bin/ksh
set -e
set -u
PS4=
set -x

# Command definition
HDIUTIL=/usr/bin/hdiutil
HDIUTIL_ATTACH="$HDIUTIL attach -quiet -nobrowse"
HDIUTIL_CREATE="$HDIUTIL create -ov -format UDBZ"
HDIUTIL_DETACH="$HDIUTIL detach -quiet"
MD5=/sbin/md5
MKTEMP=/usr/bin/mktemp
OPEN=/usr/bin/open
PATCH=/usr/bin/patch
RSYNC="/usr/bin/rsync -a"

# Variable definition
_MIKU_DMG=$1
_MIKU_DMG_VOLUME_NAME=MikuInstaller
_MIKU_APP_NAME=MikuInstaller.app
_MIKU_WINE_BUNDLE_PREFIX=$_MIKU_APP_NAME/Contents/Resources/Wine.bundle
_MIKU_WINE_BUNDLE_PLIST=$_MIKU_WINE_BUNDLE_PREFIX/Contents/Info.plist

_MY_NAME=MikuInstaller+
_MY_VERSION=@VERSION@
_MY_WINE_VERSION=@WINE_VERSION@
_MY_PREFIX=$(cd "$(dirname "$0")" && pwd)
_MY_DATA_DIR=$_MY_PREFIX/.rsrc
_MY_NEW_DMG_FILE_NAME=$_MY_NAME-${_MY_VERSION//-/}.dmg
_MY_NEW_DMG_VOLUME_NAME=$_MY_NAME

#-------------------------------------------------------------------------------

# Check MikuInstaller disk image
set -- $($MD5 -q "$_MIKU_DMG")
case $1 in
36b33041fea516faccddc18413ea23cc)
    ;;
*)
    echo "Invalid disk image: $_MIKU_DMG"
    exit 1
    ;;
esac


# Import MikuInstaller resources
set -- $($MKTEMP -u -t $$)
$HDIUTIL_ATTACH "$_MIKU_DMG" -mountpoint "$1"
$RSYNC -mR --filter='. -' "$1"/./"$_MIKU_APP_NAME" . <<!
+ SharedSupport/share/
+ SharedSupport/share/wine/
+ SharedSupport/share/wine/fonts/
+ SharedSupport/share/wine/fonts/ume-*.ttf
- SharedSupport/**
- SharedFrameworks/
- addapp.sh
- createapp.sh
- infoplist.awk
- startx11.sh
- shellexec.exe.so
- startmenu.exe.so
!
$HDIUTIL_DETACH "$1"


# Update MikuInstaller resources
$RSYNC -R "$_MY_DATA_DIR"/./"$_MIKU_APP_NAME" .
$PATCH -Nsp1 < "$_MY_DATA_DIR"/patch.diff
$PATCH -Nsp1 < "$_MY_DATA_DIR"/patch-plist.diff


# Create new disk image
$HDIUTIL_CREATE "$_MY_NEW_DMG_FILE_NAME" \
    -srcdir  "$_MIKU_APP_NAME" \
    -volname "$_MY_NEW_DMG_VOLUME_NAME"
