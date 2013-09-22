#!/bin/sh

SERVER_HOST=games.kyleracette.com
UPLOAD_DIR=/home/kyle/.web_uploads
UPLOAD_USER=kyle
WEB_DIR=../web
OUTFILE=beer_run.dart.js
INFILE=beer_run.dart
DATETIME=$( date +'%Y%m%d%H%M%S' )

if [ "$1" = dev ] || [ "$1" = DEV ]; then
	CMD="dart2js --checked --analyze-all --disallow-unsafe-eval --enable-diagnostic-colors --out=$OUTFILE $INFILE"
else
	CMD="dart2js --analyze-only --minify --out=$OUTFILE $INFILE"
fi

#cd $WEB_DIR
#$CMD

BACKUP_CMD="mv /opt/www/$SERVER_HOST/app /opt/www/$SERVER_HOST/archive/app.$DATETIME"
MKDIR_CMD="mkdir -p /opt/www/$SERVER_HOST/app/web"
COPY_CMD="mv $UPLOAD_DIR/* /opt/www/$SERVER_HOST/app/web"

rsync --exclude=audio -arv ../deploy/* $UPLOAD_USER@$SERVER_HOST:$UPLOAD_DIR
ssh $UPLOAD_USER@$SERVER_HOST "$BACKUP_CMD ; $MKDIR_CMD && $COPY_CMD"


