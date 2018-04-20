#!/bin/bash
set -eu

TEST_DIRECTORY="test"
ERROR_MESSAGE="internal compiler error"
CARGO_COMMAND="test"
DEBUG=false
SEARCH_FIX=false

cargo_absolute="$(readlink -e "${CARGO_RELATIVE}")"

cd "${TEST_DIRECTORY}"
rm -rf target
out=$("${cargo_absolute}" ${CARGO_COMMAND} 2>&1 || true)
"${DEBUG}" && echo "${out}"

if "${SEARCH_FIX}"; then
    if echo "${out}" | grep -q "${ERROR_MESSAGE}"; then
        exit 1
    fi
    exit 0
fi

echo "${out}" | grep -q "${ERROR_MESSAGE}"
