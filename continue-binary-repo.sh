#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

function call {
    echo -e "${RED} $* ${NC}"
    $* || exit 2
}

function call_safe {
    echo -e "${RED} $* ${NC}"
    $*
}

source ./env.sh

CURDIR=$(pwd)

OPAMROOT=$CURDIR/root
OPAMBIN=$OPAMROOT/plugins/opam-bin/opam-bin.exe

export OPAMROOT

echo CURDIR: $CURDIR
call opam update

call_safe opam switch remove build-bin -y
call opam switch create build-bin --empty

call opam install -y $(cat distribution$1.txt)

#echo $(opam list | awk '{ print $1 "." $2 }')

call $OPAMBIN list

echo
echo Use the following command to push these files
echo ./opam-bin.sh push
echo
