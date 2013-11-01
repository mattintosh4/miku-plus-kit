#!/bin/sh
PS4=
define(){ eval ${1:?}=\"\${*\:2}\"; }

set -e
set -u
set -x

define  PROJECT_NAME        MikuPlusKit
define  PROJECT_REALNAME    MikuInstaller+ Kit
define  PROJECT_ROOT        $(cd "$(dirname "$0")"; pwd)

define  DITTO               /usr/bin/ditto
define  GIT                 /opt/local/bin/git
define  HDIUTIL             /usr/bin/hdiutil
define  INSTALL             /usr/bin/install
define  LN                  /bin/ln
define  MKTEMP              /usr/bin/mktemp
define  SED                 /usr/bin/sed
define  PERL                /usr/bin/perl
define  PERL_MD_MODULE      $PROJECT_ROOT/Markdown.pl

define  PROJECT_VERSION     $(GIT_DIR=$PROJECT_ROOT/.git $GIT log -1 --pretty --date=short --format=%ad) ; : ${PROJECT_VERSION}
define  PROJECT_HASH        $(GIT_DIR=$PROJECT_ROOT/.git $GIT log -1 --pretty --format=%h)               ; : ${PROJECT_HASH}
define  PROJECT_URL         https://github.com/mattintosh4/miku-plus-kit

define  BUNDLE_SOURCE       $1
define  BUNDLE_NAME         Wine.bundle
define  BUNDLE_VERSION      $($BUNDLE_SOURCE/bin/wine --version)

define  DISTFILE_VOLN       ${PROJECT_NAME}_${PROJECT_VERSION}
define  DISTFILE_NAME       ${PROJECT_NAME}_${PROJECT_VERSION}_${PROJECT_HASH}.dmg
define  DISTFILE_PATH       $PROJECT_ROOT/$DISTFILE_NAME

#-------------------------------------------------------------------------------

make_readme()
{
    {
        cat <<EOS
<!doctype html>
<html>
<head>
<meta charset="utf-8" />
<link rel="stylesheet" href=".rsrc/style.css" />
<title>$PROJECT_REALNAME $PROJECT_VERSION</title>
</head>
<body>
EOS
        $PERL $PERL_MD_MODULE $PROJECT_ROOT/README.md
        cat <<EOS
</body>
</html>
EOS
    } | tr -d "\n" > $tmpdir/README.html

    $INSTALL -m 0644 $PROJECT_ROOT/README.css $tmpdir_rsrc/style.css
}

main()
{
    tmpdir=$($MKTEMP -d -t $$$$)
    tmpdir_rsrc=$tmpdir/.rsrc
    trap "rm -rf $tmpdir" SIGINT EXIT

    $DITTO $BUNDLE_SOURCE $tmpdir_rsrc/$BUNDLE_NAME/Contents/SharedSupport
    $LN -s SharedSupport  $tmpdir_rsrc/$BUNDLE_NAME/Contents/SharedFrameworks

    $INSTALL -m 0755 $PROJECT_ROOT/update.sh.in  $tmpdir/update.sh
    $INSTALL -m 0755 $PROJECT_ROOT/main.sh.in    $tmpdir_rsrc/main.sh
    $INSTALL -m 0644 $PROJECT_ROOT/patch.diff.in $tmpdir_rsrc/patch.diff

    make_readme

    items=(
        $tmpdir_rsrc/main.sh
        $tmpdir_rsrc/patch.diff
        $tmpdir/README.html
        $tmpdir/update.sh
    )
    $SED -i "" "
        s|@VERSION@|$PROJECT_VERSION|g
        s|@WINE_VERSION@|$BUNDLE_VERSION|g
        s|@DISTFILE_NAME@|$DISTFILE_NAME|g
        s|@GitHub@|$PROJECT_URL|g
    " "${items[@]}"

    $HDIUTIL create -ov -attach \
        -format  UDBZ \
        -srcdir  $tmpdir \
        -volname $DISTFILE_VOLN \
                 $DISTFILE_PATH
}

#-------------------------------------------------------------------------------

case ${BUNDLE_VERSION:?} in
wine-1.*)
    main
    ;;
esac
