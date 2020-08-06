#!/bin/bash

# Directory 'distribs' contains "distribution-$VERSION.txt" files
# containing requirements on packages, that are transformed into


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

export OPAMROOT=$HOME/.opam
call_safe opam switch remove empty -y
call opam switch create empty --empty -y

for version in 4.07.1 4.08.1 4.09.1 4.10.0; do

    echo $version

    echo Computing distribs/solution-$version.txt
    opam install --show-actions $(cat distribs/distribution-$version.txt) | sort > distribs/solution-$version.txt
    echo Generating distribution-$version.txt
    awk '{ print $3 "." $4 }' < distribs/solution-$version.txt | grep -v actions.would | grep -v ===== > distribution-$version.txt

done
