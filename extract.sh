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
export OPAMROOT=$CURDIR/root

call opam bin --version

for version in 4.07.1 4.08.1 4.09.1 4.10.0; do
    call opam bin push --delete --extract $version:ocaml-base-compiler.$version
done
call opam bin push --local-only
