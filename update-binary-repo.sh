#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

function call {
    echo -e "${RED} $* ${NC}"
    $* || exit 2
}

CURDIR=$(pwd)

source ./env.sh

RSYNC_URL=$CURDIR/remote
OCAML_VERSION=4.07.1

export OPAMROOT=$CURDIR/root
OPAMBIN=$OPAMROOT/plugins/opam-bin/opam-bin.exe

CURDIR=$(pwd)

source ./env.sh

call mkdir -p download-cache
call mkdir -p remote

if ! [ -d root ] ; then
    call opam init --bare -n  file://$OPAM_REPO
    call rm -rf $OPAMROOT/download-cache
    call ln -s ../download-cache $OPAMROOT/download-cache
fi

call opam repo set-url default --all --set-default file://$OPAM_REPO -y

if ! [ -d $OPAMROOT/repo/opam-bin ]; then
  call opam repo add opam-bin --all --set-default file://$OPAMBIN_REPO -y
fi

if ! [ -d $OPAMROOT/opam-bin ] ; then
    call opam switch create opam-bin $OCAML_VERSION
fi

cd $OPAMBIN_SRCDIR
pwd
eval $(opam env)
call opam switch opam-bin
call opam install --deps-only . -y
call opam exec -- make
call ./opam-bin config --patches-url file://$PATCHES_DIR
call ./opam-bin install
cd $CURDIR
pwd

call opam bin config --patches-url file://$PATCHES_DIR
call opam bin install patches

call $OPAMBIN config --base-url $BASE_URL
call $OPAMBIN config --rsync-url $RSYNC_URL

pull="true"

if [ "$1" == "--delete" ] ; then
    call $OPAMBIN clean
    pull="false"
fi

if [ "$1" == "--nopull" ] ; then
    pull="false"
fi

if [ "$pull" == "true" ] ; then
    call $OPAMBIN pull
fi


if [ -d $OPAMROOT/$OCAML_VERSION ] ; then

    call opam switch remove $OCAML_VERSION -y

fi

call ./continue-binary-repo.sh

# call $OPAMBIN push
