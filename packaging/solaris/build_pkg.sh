#!/bin/sh
# Shell script for building Solaris package of rsync
# Author: Jens Apel <jens.apel@web.de>
# License: GPL
#
# BASEDIR is /usr/local and should be the same as the
# --prefix parameter of configure
#
# this script should be copied under
# packaging/solaris/5.8/build_pkg.sh

# Definitions start here
# you can edit this, if you like

# The Package name under which rsync will b installed
PKGNAME=SMBrsync

# Extract common info requires for the 'info' part of the package.
# This should be made generic and generated by the configure script
# but for now it is hard coded
BASEDIR=/usr/local
VERSION="2.5.5"
ARCH=`uname -p`
NAME=rsync

# Definitions end here
# Please do not edit below this line or you know what you do.

## Start by faking root install
echo "Creating install directory (fake $BASEDIR)..."
START=`pwd`
FAKE_ROOT=$START/${PKGNAME}
mkdir $FAKE_ROOT

# copy the binary and the man page to their places
mkdir $FAKE_ROOT/bin
mkdir -p $FAKE_ROOT/doc/rsync
mkdir -p $FAKE_ROOT/man/man1
mkdir -p $FAKE_ROOT/man/man5

cp ../../../rsync $FAKE_ROOT/bin/rsync
cp ../../../rsync.1 $FAKE_ROOT/man/man1/rsync.1
cp ../../../rsyncd.conf.5 $FAKE_ROOT/man/man5/rsyncd.conf.5
cp ../../../README.md $FAKE_ROOT/doc/rsync/README.md
cp ../../../COPYING $FAKE_ROOT/doc/rsync/COPYING
cp ../../../tech_report.pdf $FAKE_ROOT/doc/rsync/tech_report.pdf
cp ../../../COPYING $FAKE_ROOT/COPYING

## Build info file
echo "Building pkginfo file..."
cat > $FAKE_ROOT/pkginfo << EOF_INFO
PKG=$PKGNAME
NAME=$NAME
DESC="Program for efficient remote updates of files."
VENDOR="Samba Team URL: http://samba.anu.edu.au/rsync/"
BASEDIR=$BASEDIR
ARCH=$ARCH
VERSION=$VERSION
CATEGORY=application
CLASSES=none
EOF_INFO

## Build prototype file
cat > $FAKE_ROOT/prototype << EOFPROTO
i copyright=COPYING
i pkginfo=pkginfo
d none bin 0755 bin bin
f none bin/rsync 0755 bin bin
d none doc 0755 bin bin
d none doc/$NAME 0755 bin bin
f none doc/$NAME/README.md 0644 bin bin
f none doc/$NAME/COPYING 0644 bin bin
f none doc/$NAME/tech_report.pdf 0644 bin bin
d none man 0755 bin bin
d none man/man1 0755 bin bin
f none man/man1/rsync.1 0644 bin bin
d none man/man5 0755 bin bin
f none man/man5/rsyncd.conf.5 0644 bin bin
EOFPROTO

## And now build the package.
OUTPUTFILE=$PKGNAME-$VERSION-sol8-$ARCH-local.pkg
echo "Building package.."
echo FAKE_ROOT = $FAKE_ROOT
cd $FAKE_ROOT
pkgmk -d . -r . -f ./prototype -o
pkgtrans -os . $OUTPUTFILE $PKGNAME

mv $OUTPUTFILE ..
cd ..

# Comment this out if you want to see, which file structure has been created
rm -rf $FAKE_ROOT

