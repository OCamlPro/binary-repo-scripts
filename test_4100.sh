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

CURDIR=$(pwd)
export OPAMROOT=$CURDIR/root4100
call rm -rf $OPAMROOT
call opam init --bare file://$CURDIR/root/plugins/opam-bin/store/4.10.0 -n
call opam switch create empty --empty -y
call opam install alt-ergo -y
