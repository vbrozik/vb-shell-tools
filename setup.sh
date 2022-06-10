#!/bin/sh

# vb-shell-tools
# Install the tools

# instalation source for scripts
src_bin_dir=scripts
# installation source for functions, aliases, vairables, etc.
src_rc_dir=functions
# destination for functions (WARNING: changing here is not enough!)
rcdir="$HOME/.bashrc.d"

#region --- functions ---

install_file () {
    # $1: source file
    # $2: destination directory
    if test -n "$editable" ; then
        ln -bv -s -r "$1" "$2"
        # -r creates relative symlinks related to pwd, GNU extension
    else
        cp -bv "$1" "$2"
    fi
}

errexit () {
    # $1: error message
    echo "$1" 1>&2
    exit 1
}

escape_ere () {
    # escape string in $1 for extended regex
    printf %s\\n "$1" | sed -E 's/([[$.(+*{^\])/\\\1/g'
}

#endregion

#region --- Read CLI arguments using getopts

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

#endregion

#region --- Install scripts ---

dst_bin_dir=""
for bin_dir in "$HOME/.local/bin" "$HOME/bin" ; do
    case :$PATH: in
        *:$bin_dir:*)
            dst_bin_dir="$bin_dir"
            break
    esac
done

if test -z "$dst_bin_dir" ; then
    for bin_dir in "\$HOME/.local/bin" "\$HOME/bin" ; do
        if grep -Eq '^if +\[ +-d .*'"$(escape_ere "$bin_dir")" \
                "$HOME/.profile" ; then
            dst_bin_dir="$(eval printf %s "$bin_dir")"
            echo "Creating directory: $dst_bin_dir"
            mkdir -vp "$dst_bin_dir" || errexit "Cannot create $dst_bin_dir"
            echo "Restart your shell to get it into your PATH" \
                "or run 'source ~/.profile' to reload the new PATH."
            break
        fi
    done
fi

if test -z "$dst_bin_dir" ; then
    echo "ERROR: No suitable destination bin directory in PATH found."
    exit 1
fi

echo "Installing in $dst_bin_dir"

mkdir -vp "$dst_bin_dir"

for file in "$src_bin_dir"/* ; do
    if test -r "$file" ; then
        chmod +x "$file"
        install_file "$file" "$dst_bin_dir"
    fi
done

#endregion

#region --- Install functions and aliases ---

mkdir -vp "$rcdir"

for file in "$src_rc_dir"/* ; do
    test -r "$file" && install_file "$file" "$rcdir"
done

rcfile="$HOME/.bashrc"

if ! grep -q '^# start ~/\.bashrc\.d reader' "$rcfile" ; then
    {   echo
        cat fragments/bashrc_d.sh
        echo
    } >> "$rcfile"
fi

#endregion
