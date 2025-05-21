#!/bin/sh

# This file contains snippets for basic computations.

# shellcheck disable=SC2317   # This is a collection of snippets, not a script.
exit 1

# Extract fields with integer numeric values from each line of input.

awk '{
  output = ""
  for (i=1; i<=NF; i++) {
    if ($i ~ /^[0-9]+$/) {
      if (output != "") {
        output = output " " $i
      } else {
        output = $i
      }
    }
  }
  if (output != "") {
    print output
  }
}'

# Calculate the average and maximum of the first column of input.

awk '
    { total += $1; count++ }
    max < $1 { max = $1 }
    END { print total/count " " max }
    '
