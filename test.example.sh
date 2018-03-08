#!/bin/bash
set -eu

TEST_DIRECTORY="test"
ERROR_MESSAGE="internal compiler error"
CARGO_COMMAND="test"

cargo_absolute="$(readlink -e "${CARGO_RELATIVE}")"

cd "${TEST_DIRECTORY}"
rm -rf target
"${cargo_absolute}" "${CARGO_COMMAND}" 2>&1 | grep -q "${ERROR_MESSAGE}"
