#!/bin/bash
set -euo pipefail

if [[ "$#" -ne 2 ]]; then
    echo "Usage: ./bisect.sh <start> <end>"
    exit 1
fi

export RUST_LOG=rust_sysroot=info,bisect=info
cargo run --release --bin bisect -- --preserve --test test.sh --start "$1" --end "$2"
