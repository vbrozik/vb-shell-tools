#!/bin/sh

# This file contains basic functions to be copied into shell scripts.

# --- Dummy variable setting
log_file=
prog_name=

# Print error message and exit the program.
errexit () {
    printf 'Fatal error (%s exiting): %s\n' "$prog_name" "$*" >&2
    exit 1
}

# Print date for logging.
log_time () {
    # Date in ISO 8601 format with time zone:
    date -Is
}

# Log a message.
# Variables and functions used:
#   - log_time ()
#   - log_file
#   - prog_name
log () {
    printf '%s %s: %s' "$(log_time)" "$prog_name" "$*"  >> "$log_file"
}
