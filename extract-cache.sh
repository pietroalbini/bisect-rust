#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: ./extract-cache.sh <commit>"
    exit 1
fi

rm -rf "cache/$1"
mkdir "cache/$1"
for component in rustc cargo rust-std; do
    tar xvf "cache/${1}-x86_64-unknown-linux-gnu-${component}.tar.xz" --strip-components=2 -C "cache/$1"
done
