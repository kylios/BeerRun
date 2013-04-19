#!/bin/sh

SERVER_HOST=kyleracette.com
UPLOAD_DIR=/home/www/sites/games/public_html/
UPLOAD_USER=kyle

rsync -rv ../web/* $UPLOAD_USER@$SERVER_HOST:$UPLOAD_DIR

