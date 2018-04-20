#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$#" -ne 1 ]]; then
    echo "Usage: ./cutoff.sh <tag>"
    exit 1
fi

git -C rust.git merge-base "$1" origin/master
