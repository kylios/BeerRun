#!/usr/bin/env bash

. ./config.sh
. ./utils.sh


shopt -s extglob
scp -i $AWSDIR/keypairs/webserver.pem -r ../build/!(release*) ubuntu@beerrungame.net:/home/ubuntu/releases/latest/
shopt -u extglob

exit



SSH_USER=ubuntu
DEPLOY_HOST=184.169.162.25
SSH_KEY=$KEYPAIRS_DIR/webserver.pem
S3_BASE_URL="https://s3-us-west-1.amazonaws.com/beerrun/releases"
APP_DIR="/opt/www/beerrungame.net/app"
SYMLINK="$APP_DIR/web"
RELEASE_DIR="/home/$SSH_USER/releases"
LINK_TARGET="$RELEASE_DIR/$OUT"

SSH_COMMAND="ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@$DEPLOY_HOST"
echo
echo "Deploying..."
echo $SSH_COMMAND
$SSH_COMMAND "bash -s" <<EOF
mkdir $RELEASE_DIR >/dev/null 2>&1 ; 
cd $RELEASE_DIR ; 
wget "$S3_BASE_URL/$OUT_TGZ" ; 
tar -xvf "$OUT_TGZ" ; 
rm $SYMLINK >/dev/null 2>&1 ; 
ln -sd $LINK_TARGET $SYMLINK
EOF
