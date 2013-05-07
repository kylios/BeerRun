#!/bin/sh

SERVER_HOST=games.kyleracette.com
UPLOAD_DIR=/home/kyle/.web_uploads
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

rsync --exclude=audio -rv ../* $UPLOAD_USER@$SERVER_HOST:$UPLOAD_DIR
ssh $UPLOAD_USER@$SERVER_HOST "mv $UPLOAD_DIR/* /opt/www/$SERVER_HOST/"


