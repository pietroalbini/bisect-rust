#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: ./extract-cache.sh <commit>"
    exit 1
fi

target="$(rustc -vV | grep host | awk '{print($2)}')"

rm -rf "cache/$1"
mkdir "cache/$1"
for component in rustc cargo rust-std; do
    tar xvf "cache/${1}-${target}-${component}.tar.xz" --strip-components=2 -C "cache/$1"
done
