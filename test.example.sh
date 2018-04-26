#!/bin/bash
set -eu



# The directory with the test case
TEST_DIRECTORY="test"

# The error message to search for. This is usually "internal compiler error"
# for ICEs, or just "error" if a new error was introduced
ERROR_MESSAGE="internal compiler error"

# The cargo command to be used ("build", "test", "check", "doc --no-deps"...)
CARGO_COMMAND="test"

# If this is set to `true`, the build output is shown during the bisect
SHOW_OUTPUT=false

# If this is set to `true`, bisect will look for the PR which fixed the
# regression, instead of the one which caused it
SEARCH_FIX=false



cargo_absolute="$(readlink -e "${CARGO_RELATIVE}")"

cd "${TEST_DIRECTORY}"
rm -rf target
out=$("${cargo_absolute}" ${CARGO_COMMAND} 2>&1 || true)
"${SHOW_OUTPUT}" && echo "${out}"

if "${SEARCH_FIX}"; then
    if echo "${out}" | grep -q "${ERROR_MESSAGE}"; then
        exit 1
    fi
    exit 0
fi

echo "${out}" | grep -q "${ERROR_MESSAGE}"
