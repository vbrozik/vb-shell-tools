#!/bin/sh

# vb-shell-tools
# Install the tools

# TODO
# - install functions - probably to ~/.bash_aliases

src_bin_dir=scripts
src_rc_dir=functions

# Read CLI arguments using getopts

while getopts "he" opt; do
    case $opt in
        h)
            echo "Usage: $0 [-h]"
            echo "  -h: show this help"
            echo "  -e: install in editable mode (as symlinks)"
            exit 0
            ;;
        e)
            editable=true
            ;;
        *)
            # \?) cho "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

dst_bin_dir=""
for bin_dir in "$HOME/.local/bin" "$HOME/bin" ; do
    case :$PATH: in
        *:$bin_dir:*)
            dst_bin_dir="$bin_dir"
            break
    esac
done

if test -z "$dst_bin_dir" ; then
    echo "ERROR: No suitable destination bin directory in PATH found."
    exit 1
fi

echo "Installing in $dst_bin_dir"

mkdir -vp "$dst_bin_dir"

for file in "$src_bin_dir"/* ; do
    if test -f "$file" ; then
        chmod +x "$file"
        if test -n "$editable" ; then
            ln -bv -s -r "$file" "$dst_bin_dir"
            # -r creates relative symlinks related to pwd, GNU extension
        else
            cp -bv "$file" "$dst_bin_dir"
        fi
    fi
done

# Functions and aliases

rcdir="$HOME/.bashrc.d"

mkdir -vp "$rcdir"

for file in "$src_rc_dir"/* ; do
    if test -r "$file" ; then
        if test -n "$editable" ; then
            ln -bv -s -r "$file" "$rcdir"
            # -r creates relative symlinks related to pwd, GNU extension
        else
            cp -bv "$file" "$rcdir"
        fi
    fi
done

rcfile="$HOME/.bashrc"

if ! grep -q '^# start ~/\.bashrc\.d reader' "$rcfile" ; then
    {   echo
        cat fragments/bashrc_d.sh
        echo
    } >> "$rcfile"
fi
