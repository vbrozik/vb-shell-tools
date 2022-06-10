#!/bin/sh

# vb-shell-tools

# Commont tools used by other functions

# version numbers comparison

verlte() {
        # Check if version $1 is less than or equal to $2
        [  "$1" = "$(printf %s\\n "$1" "$2" | sort -V | head -n1)" ]
}

vergte() {
        # Check if version $1 is greater than or equal to $2
        [  "$1" = "$(printf %s\\n "$1" "$2" | sort -rV | head -n1)" ]
}
