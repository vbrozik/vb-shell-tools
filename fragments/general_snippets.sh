#!/bin/sh


# This file is not intended to be executed.
# It is a collection of general snippets.
# shellcheck disable=SC2317     # The file is not to be executed
exit 1

# Copy binary and/or multiple files over clipboard

# Source machine:
tar -cz files_to_copy* | base64
# If clipboard is accessible by commands add: | xclip -selection clipboard

# Destination machine:
# If clipboard is accessible by commands add: xclip -selection clipboard -o
base64 -d | tar -xzv
