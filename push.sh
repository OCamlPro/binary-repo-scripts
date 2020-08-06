#!/bin/sh

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
export OPAMROOT=$CURDIR/root

cp -f distribs/header.html root/plugins/opam-bin/header.html
cp -f distribs/trailer.html root/plugins/opam-bin/trailer.html
