#!/bin/sh

SERVER_HOST=kyleracette.com
UPLOAD_DIR=/home/www/sites/games/public_html/
UPLOAD_USER=kyle
WEB_DIR=../web
OUTFILE=beer_run.dart.js
INFILE=beer_run.dart

if [ "$1" = dev ] || [ "$1" = DEV ]; then
	CMD="dart2js --checked --analyze-all --disallow-unsafe-eval --enable-diagnostic-colors --out=$OUTFILE $INFILE"
else
	CMD="dart2js --analyze-only --minify --out=$OUTFILE $INFILE"
fi

#cd $WEB_DIR
#$CMD

rsync -rv ../web/* $UPLOAD_USER@$SERVER_HOST:$UPLOAD_DIR

