#!/bin/sh
set -e
set -u

define(){ eval ${1:?}=\"\${*\:2}\"; }

set -a

define  PROJECT_NAME        MikuPlusKit
define  PROJECT_ROOT        $(cd "$(dirname "$0")"; pwd)
define  PROJECT_VERSION     $(date +%Y%m%d)
define  PROJECT_URL         https://github.com/mattintosh4/miku-plus-kit

define  BUNDLE_SOURCE       $1
define  BUNDLE_CONTENTS     Wine.bundle/Contents
define  BUNDLE_VERSION      $($BUNDLE_SOURCE/bin/wine --version)
    
define  DISTFILE_VOLN       ${PROJECT_NAME}_$PROJECT_VERSION
define  DISTFILE_PATH       $PROJECT_ROOT/$DISTFILE_VOLN.dmg

define  DITTO               /usr/bin/ditto
define  HDIUTIL             /usr/bin/hdiutil
define  INSTALL             /usr/bin/install
define  LN                  /bin/ln
define  MKTEMP              /usr/bin/mktemp
define  SED                 /usr/bin/sed

define  PS4

main()
{
    tmpdir=$($MKTEMP -d -t $PROJECT_NAME)
    trap "rm -rf $tmpdir" EXIT SIGINT

    $DITTO $BUNDLE_SOURCE $tmpdir/.rsrc/$BUNDLE_CONTENTS/SharedSupport
    $LN -s SharedSupport  $tmpdir/.rsrc/$BUNDLE_CONTENTS/SharedFrameworks

    $INSTALL -m 0644 $PROJECT_ROOT/README.html            $tmpdir/README.html
    $INSTALL -m 0755 $PROJECT_ROOT/miku-plus-kit.sh.in    $tmpdir/miku-plus-kit.sh
    $INSTALL -m 0644 $PROJECT_ROOT/miku-plus-kit.patch.in $tmpdir/.rsrc/miku-plus-kit.patch
    echo $PROJECT_VERSION >$tmpdir/VERSION
    $SED -i "" "
        s|@VERSION@|$PROJECT_VERSION|g
        s|@WINE_VERSION@|$BUNDLE_VERSION|g
        s|@GitHub@|$PROJECT_URL|g
    "   $tmpdir/miku-plus-kit.sh \
        $tmpdir/README.html

    $HDIUTIL create -ov -attach \
        -format  UDBZ \
        -srcdir  $tmpdir \
        -volname $DISTFILE_VOLN \
                 $DISTFILE_PATH
}

case $BUNDLE_VERSION in
wine-1.*)
    sh -eux -c main
    ;;
esac
