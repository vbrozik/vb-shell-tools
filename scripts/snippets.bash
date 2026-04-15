#!/bin/bash

# Useful shell snippets for various tasks.

# shellcheck disable=SC2317     # This file is not meant to be executed.
# shellcheck disable=SC2329     # This file is not meant to be executed.
# shellcheck disable=SC2034     # This file is not meant to be executed.
exit 0
#########################################################################

# Text file tools

## Pipe to show lines with CRLF line endings (Windows-style) in a file:
cat -e | grep -E '\^M\$$'

## Show filenames with CRLF line endings (Windows-style):
grep -RUPl '\r$'
## Variant for bash not requiring PCRE (-P):
grep -RUl $'\r$'
