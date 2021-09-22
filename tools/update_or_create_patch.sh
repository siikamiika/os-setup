#!/bin/sh

UPSTREAM_FILE="$1"
FORKED_FILE="$2"
DIR="$3"

PATCH="$DIR/$(basename "$FORKED_FILE").patch"
PATCH_TMP="$PATCH.tmp"

diff "$UPSTREAM_FILE" "$FORKED_FILE" > "$PATCH_TMP"
diff "$PATCH" "$PATCH_TMP"
code=$?

if [ $code -eq 0 ]; then
    echo "Nothing has changed"
    rm "$PATCH_TMP"
elif [ $code -eq 1 ]; then
    mv "$PATCH_TMP" "$PATCH"
    echo "Updated $PATCH"
elif [ $code -eq 2 ]; then
    if [ ! -e "$PATCH" ]; then
        mv "$PATCH_TMP" "$PATCH"
        echo "Created $PATCH"
    else
        echo "Unknown error in diff" && exit 2
    fi
else
    "Unknown error"
    exit 1
fi
