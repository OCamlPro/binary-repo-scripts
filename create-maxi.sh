#!/bin/sh

opam install $(cat ../distribution-4.10.0.txt ) --criteria +new --show-actions &> distrib-maxi.txt || exit 2
awk '{ print $3 "." $4 }' < distrib-maxi.txt > distribution-maxi.txt
