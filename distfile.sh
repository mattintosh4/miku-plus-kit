#!/bin/ksh
set -e
set -u
PS4=
set -x

# Command definition
CAT=/bin/cat
HDIUTIL=/usr/bin/hdiutil
HDIUTIL_CREATE="$HDIUTIL create -ov -format UDBZ"
INSTALL=/usr/bin/install
LN=/bin/ln
MKDIR="/bin/mkdir -p"
MKTEMP=/usr/bin/mktemp
PERL=/usr/bin/perl
RM=/bin/rm
RSYNC="/usr/bin/rsync -a"
SED=/usr/bin/sed
TR=/usr/bin/tr

# External command definition
GIT=/usr/local/git/bin/git


# Variable definition
_WINE_SOURCE_DIR=$1
_WINE_VERSION=wine-1.7.9

_PROJECT_SOURCE_DIR=$(cd "$(dirname "$0")" && pwd)
_PROJECT_NAME=MPK
_PROJECT_VERSION=$(GIT_DIR=$_PROJECT_SOURCE_DIR/.git $GIT log -1 --pretty --date=short --format=%ad)

_DISTFILE_NAME=$_PROJECT_NAME\_$_PROJECT_VERSION
_DISTFILE_VOLUME_NAME=$_PROJECT_NAME

#-------------------------------------------------------------------------------

tempdir=$($MKTEMP -d -t $$)
trap "$RM -r $tempdir" INT EXIT
cd $tempdir

set -- .rsrc/MikuInstaller.app/Contents/Resources/Wine.bundle/Contents/Resources
$MKDIR "$1"
$RSYNC -R --filter='- .DS_Store' "$_WINE_SOURCE_DIR"/./ "$1"/SharedSupport
$LN -s SharedSupport "$1"/SharedFrameworks


$INSTALL -m 0755 "$_PROJECT_SOURCE_DIR"/update.sh        update.sh
$INSTALL -m 0644 "$_PROJECT_SOURCE_DIR"/patch.diff       .rsrc/patch.diff
$INSTALL -m 0644 "$_PROJECT_SOURCE_DIR"/patch-plist.diff .rsrc/patch-plist.diff
$INSTALL -m 0644 "$_PROJECT_SOURCE_DIR"/README.css       .rsrc/README.css

{
$CAT <<!
<!doctype html><html><head><meta charset="utf-8" /><link rel="stylesheet" href=".rsrc/README.css" /><title>$_PROJECT_NAME $_PROJECT_VERSION</title></head><body>
!
$PERL "$_PROJECT_SOURCE_DIR"/Markdown.pl \
      "$_PROJECT_SOURCE_DIR"/README.md
$CAT <<!
</body></html>
!
} \
| $TR -d '\n' \
> README.html


set -- update.sh \
       README.html \
       .rsrc/patch.diff \
       .rsrc/patch-plist.diff
$SED -i '' -f /dev/fd/0 "$@" <<!
s/@VERSION@/$_PROJECT_VERSION/g
s/@WINE_VERSION@/$_WINE_VERSION/g
s/@DISTFILE_NAME@/$_DISTFILE_NAME/g
s/@DISTFILE_VOLUME_NAME@/$_DISTFILE_VOLUME_NAME/g
!

$HDIUTIL_CREATE -srcdir . -volname "$_DISTFILE_VOLUME_NAME" "$_PROJECT_SOURCE_DIR"/"$_DISTFILE_NAME"
