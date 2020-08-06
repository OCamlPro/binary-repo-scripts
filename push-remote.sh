#!/bin/sh

CURDIR=$(pwd)

. ./env.sh

echo rsync -auv $CURDIR/remote/. ${REMOTE_URL}/.
rsync -auv $CURDIR/remote/. ${REMOTE_URL}/.
