#!/bin/bash

# vb-shell-tools

# The code in this file sources files in the .bashrc.d directory.
# Source it to reload the definitions.

# Filenames staring with '_' are ignored.
# You can put an ordering number before '_' to enable the file to be sourced.
# But do not rename this file!

_this_dir="$(dirname "${BASH_SOURCE[0]}")"
test -d "$_this_dir" ||
    { echo "ERROR: $_this_dir is not a directory" ; return 1 ; }
_this_dir="$(cd "$_this_dir" && pwd)"
test -d "$_this_dir" ||
    { echo "ERROR: $_this_dir is not a directory" ; return 1 ; }

# Source all the 'bashrc.d' files
for _bashrc_d_file in  "${_this_dir}"/*.sh ; do
    test -r "$_bashrc_d_file" || continue
    # Skip filenames starting with '_'.
    test "${_bashrc_d_file##_}" != "$_bashrc_d_file" && continue
    # shellcheck source=/dev/null
    . "$_bashrc_d_file"
done

unset _this_dir _bashrc_d_file
