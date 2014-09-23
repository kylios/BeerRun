#!/usr/bin/env bash

. ./config.sh
. ./utils.sh

PID_FILE=nginx.pid
ERROR_LOG=error.log
DIRECTIVES="pid $PID_FILE; error_log $ERROR_LOG;"
NGINX_CONFIG=beer_run.local.nginx.conf


cd $RUNDIR
NGINX_COMMAND="nginx -c $NGINX_CONFIG -g \"$DIRECTIVES\""
echo $NGINX_COMMAND
$NGINX_COMMAND

