#!/usr/bin/env bash

. ./config.sh
. ./utils.sh

check_command dart2js


rm -rf $BUILDDIR
mkdir "$BUILDDIR" >/dev/null 2>&1

OUTFILE=beer_run.dart.js
INDIR=$PROJECT_ROOT/web
INFILE=beer_run.dart
DEBUG=1

COMMAND="dart2js --out=$OUTFILE"

cd "$BUILDDIR"
if [ $DEBUG ]; then
	COMMAND="$COMMAND --checked"
else
	COMMAND="$COMMAND --minify"
fi

COMMAND="$COMMAND $INDIR/$INFILE"

COPY_COMMAND="rsync -arv $INDIR/ $BUILDDIR"
$COPY_COMMAND

$COMMAND

