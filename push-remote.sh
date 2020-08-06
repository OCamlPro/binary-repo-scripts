#!/bin/sh

CURDIR=$(pwd)

source ./env.sh

rsync -auv --delete $CURDIR/remote/. ${REMOTE_URL}/.
