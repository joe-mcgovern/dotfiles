#!/bin/bash

# Read from stdin
input=`cat`

# Pass stdin through the diff-so-fancy formatter
fancy=$(echo "$input" | diff-so-fancy);

# If the text contains certain headers, open less preconfigured to search for
# those patterns.
if grep -qE "(Author|modified|added|deleted): " <<< "$fancy"; then
    echo "$fancy" | less --tabs=4 -QRXFS --pattern '^(Author|modified|added|deleted):'
else
    echo "$fancy" | less --tabs=4 -QRXFS
fi
