#!/usr/bin/env bash

. ./config.sh
. ./utils.sh

OUT="release_$(date --utc +"%Y-%m-%d_%H-%M-%S")"
OUT_TGZ="$OUT.tgz"

cd $BUILDDIR

rm -rf $OUT
mkdir $OUT

shopt -s extglob
cp -PRv !(release*) $OUT/
shopt -u extglob

tar -czf "$OUT_TGZ" $OUT
rm -rf $OUT

# Upload the entire project artifact to S3
PERMISSIONS="read=uri=http://acs.amazonaws.com/groups/global/AllUsers"
S3_ARTIFACT_PATH="$BEERRUN_BUCKET_URL/releases/$OUT_TGZ"
UPLOAD_COMMAND="aws s3 cp $OUT_TGZ $S3_ARTIFACT_PATH --grants $PERMISSIONS"
echo
echo "Archiving..."
echo "$UPLOAD_COMMAND"
$UPLOAD_COMMAND

# Upload assets to S3 where they can be downloaded by the client
ASSETS_VERSION=1
S3_ASSETS_PATH="$BEERRUN_BUCKET_URL/assets/$ASSETS_VERSION"
UPLOAD_COMMAND="aws s3 cp $BUILDDIR/web/ $S3_ASSETS_PATH --recursive --grants $PERMISSIONS"
echo "$UPLOAD_COMMAND"
exit

SSH_USER=ubuntu
DEPLOY_HOST=184.169.162.25
SSH_KEY=$KEYPAIRS_DIR/webserver.pem
S3_BASE_URL="https://s3-us-west-1.amazonaws.com/beerrun/releases"
APP_DIR="/opt/www/beerrungame.net/"
SYMLINK="$APP_DIR/app"
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
ln -sd $LINK_TARGET $SYMLINK ;
rm $RELEASE_DIR/latest >/dev/null 2>&1 ;
ln -sd $LINK_TARGET $RELEASE_DIR/latest
EOF


# Also upload assets to S3
VERSION=
