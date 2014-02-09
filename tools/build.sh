#!/usr/bin/env bash

. ./config.sh
. ./utils.sh

check_command dart2js

BUILDDIR=$PROJECT_ROOT/build

rm -rf $BUILDDIR
mkdir "$BUILDDIR" >/dev/null 2>&1
mkdir "$BUILDDIR/web" >/dev/null 2>&1
mkdir "$BUILDDIR/server" >/dev/null 2>&1

OUTFILE=beer_run.dart.js
INDIR=$PROJECT_ROOT/web
INFILE=beer_run.dart
DEBUG=1

cd $INDIR
COMMAND="dart2js --out=$OUTFILE"

if [ $DEBUG ]; then
	COMMAND="$COMMAND --checked"
else
	COMMAND="$COMMAND --minify"
fi

COMMAND="$COMMAND $INFILE"
echo "$COMMAND"
$COMMAND

WEBDIR="$PROJECT_ROOT/web"
SERVERDIR="$PROJECT_ROOT/server"
rsync -arv $WEBDIR $BUILDDIR
rsync -arv $SERVERDIR $BUILDDIR

set -x

# Ugly hack to keep the dart.js file even though all
# packages dissappear from the final build
cd $BUILDDIR/web
# Kill all symbolic links
find -P . -type l -print0 | xargs -0 rm

function copy_package() {
	package=$1
		
	mkdir $package
	cp $WEBDIR/packages/$package/* ./$package
	rm packages >/dev/null 2>&1
	mkdir -p packages
	mv ./$package packages/
}

copy_package browser

set +x
