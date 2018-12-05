#!/bin/sh

set -e
set -u

C_AWK="$(which awk)"
C_SHA1SUM="$(which sha1sum)"
C_TR="$(which tr)"
C_XXD="$(which xxd)"

echo -n "Please enter the MySQL password: "
read -s PASSWORD

# check password length
if [ ${#PASSWORD} -eq 0 ]; then
    echo "Invalid password length: 0"

    exit 1
fi

# create first hash and retrieve only the hash
FIRST_HASH="$(echo -n "${PASSWORD}" | ${C_SHA1SUM} | ${C_AWK} '{print $1}')"

# output first hash as binary
FIRST_HASH_BINARY="$(echo -n "${FIRST_HASH}" | ${C_XXD} -r -p)"

# hash the first hash (binary) and retrieve only the hash
SECOND_HASH="$(echo -n "${FIRST_HASH_BINARY}" | ${C_SHA1SUM} | ${C_AWK} '{print $1}')"

# make second hash upper case
SECOND_HASH_UPPER="$(echo -n "${SECOND_HASH}" | ${C_TR} [a-z] [A-Z])"

# print final hash with leading asterisk
echo "*${SECOND_HASH_UPPER}"

exit 0

