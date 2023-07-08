#!/bin/sh

# This file contains basic functions to be copied into shell scripts.

# --- Dummy variable setting
log_file=
prog_name=
dry_run=
verbose=

# --- Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run)
            dry_run=1
            shift
            ;;
        -v|--verbose)
            verbose=1
            shift
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done


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

# Run the command dry if $dry_run is not empty.
# Status code of the command is preserved.
# In case of dry run, the status code is always 0.
run_command () {
    if test -z "$dry_run" ; then
        test -n "$verbose" && log 'Running:' "$*"
        "$@"
    else
        log 'Dry run:' "$*"
    fi
}
