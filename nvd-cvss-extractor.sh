#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ] ; then
    echo "Usage $0 INPUT OUTPUT"
fi

fgrep cvss:score $1 | sed -n 's/.*score>\([0-9.]*\)<\/cvss.*/\1/p' > $2
